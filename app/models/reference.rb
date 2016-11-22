class Reference
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic 
  extend Enumerize
  before_save :set_tag_ids

  field :name, type: String
  field :describe, type: String
  field :kind, type: String

  KINDS = ["文章", "文档", "视频", "链接"]
  enumerize :kind, in: KINDS
  
  
  has_and_belongs_to_many :tags

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
      name: self.name,
      describe: self.describe,
      kind: self.kind,
      tags: self.tag_ids.map{ |t|
        Tag.find(t).name
      }.join(",")
    }
  end

  def display_data
    {
      id: self.id.to_s,
      name: self.name,
      describe: self.describe,
      kind: KINDS,
      tags: self.tag_ids.map{ |t|
        Tag.find(t).name
      }.join(",")
    }
  end
end