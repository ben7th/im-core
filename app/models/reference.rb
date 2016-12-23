class Reference
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic 
  extend Enumerize
  before_save :set_tag_ids

  field :name, type: String
  field :describe, type: String
  field :kind, type: String
  field :reference_file_name, type: String

  validates :name, :kind, presence: true
  validate :file_name_exist

  def file_name_exist
    unless self.reference_file_name == ""
      return errors.add(:base, '文件不存在') if !SaveFile.where(:name => self.reference_file_name).present?
    end
  end

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
      all_kind: KINDS,
      tags: self.tags.map{ |tag|
        tag.simple_controller_data
      },
      reference_file_name: self.reference_file_name
    }
  end

  def simple_controller_data
    {
      id: self.id.to_s,
      name: self.name,
      describe: self.describe,
      kind: self.kind
    }
  end

end