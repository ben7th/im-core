class SaveFile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  belongs_to :file_entity, :class_name => "FilePartUpload::FileEntity"
  has_and_belongs_to_many :tags
  before_save :set_tag_ids

  def controller_data
    {
     :file_entity_name=> self.file_entity.original,
     :file_entity_type=> self.file_entity.mime,
     :name => self.name,
     :tags_name_ary => self.tags.map{|tag| tag.name}.to_a,
     :id => self.id.to_s
    }
  end

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
end
