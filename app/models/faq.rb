class Faq
  include Mongoid::Document
  include Mongoid::Timestamps

  field :question, type: String
  field :answer, type: String

  before_save :set_tag_ids

  has_and_belongs_to_many :tags
  has_and_belongs_to_many :references

  validates :question, :answer, presence: true

  def tags_name=(ary)
    @tags_name = ary 
  end

  def set_tag_ids
    if @tags_name.present?
      self.tag_ids = @tags_name.map do |tag|
        if !Tag.where(:name => tag).present?
          Tag.create(:name => tag).id
        else
          Tag.where(:name => tag).first.id
        end
      end
    end
  end

  def controller_data
    {
      id: self.id.to_s,
      question: self.question,
      answer: self.answer,
      references: self.references.map{ |ref|
        ref.simple_controller_data
      },

      tags: self.tags.map{ |tag|
        tag.simple_controller_data
      },
    }
  end

  def simple_controller_data
    {
      id: self.id.to_s,
      question: self.question,
      answer: self.answer,
    }
  end
end