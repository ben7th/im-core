class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  before_destroy :cancel_all_reletion

  validates :name, presence: true

  def cancel_all_reletion
    self.refs.each do |ref|
      ref.tag_ids -= [self.id]
      ref.save
    end

    self.faqs.each do |faq|
      faq.tag_ids -= [self.id]
      faq.save
    end
  end
  
  def refs
    Reference.where(:tag_ids.in=>[self.id]).all.to_a
  end

  def faqs
    Faq.where(:tag_ids.in=>[self.id]).all.to_a
  end

  def change_faqs(ary)
    del_ids_ary = self.faqs.map{|obj| obj.id.to_s} - ary
    add_ids_ary = ary - self.faqs.map{|obj| obj.id.to_s}

    del_ids_ary.each do |faq_id| 
      faq = Faq.find(faq_id)
      faq.tag_ids -= [self.id]
      faq.save
    end

    add_ids_ary.each do |faq_id|
      faq = Faq.find(faq_id)
      faq.tag_ids += [self.id]
      faq.save
    end
  end

  def change_refs(ary)
    del_ids_ary = self.refs.map{|obj| obj.id.to_s} - ary
    add_ids_ary = ary - self.refs.map{|obj| obj.id.to_s}
    del_ids_ary.each do |ref_id| 
      faq = Reference.find(ref_id)
      faq.tag_ids -= [self.id]
      faq.save
    end
    add_ids_ary.each do |ref_id| 
      faq = Reference.find(ref_id)
      faq.tag_ids += [self.id]
      faq.save
    end
  end

  def controller_data
    {
      id: self.id.to_s,
      name: self.name,
      faqs: self.faqs.map{ |faq|
        faq.simple_controller_data
      },

      references: self.refs.map{|ref|
        ref.simple_controller_data
      }
    }
  end

  def simple_controller_data
    {
      id: self.id.to_s,
      name: self.name
    }
  end
end