class Admin::SaveFilesController < ApplicationController
  def index
    @component_name = 'IndexSaveFilePage'
    @component_data = {
      upload_path: upload_admin_save_files_path,
      save_files: SaveFile.all.map{|save_file| save_file.index_controller_data}.to_a
    }
  end

  def upload
    @component_name = 'UploadPage'
    @component_data = {
      data: FilePartUpload.get_dom_data,
      create_path: admin_save_files_path,
      cancel_path: admin_save_files_path,
      new_path: new_admin_save_file_path,
    }
  end

  def new
    save_file = SaveFile.new
    file_entity = FilePartUpload::FileEntity.find(params[:file_entity_id])
    @component_name = 'EditSaveFilePage'
    @component_data = {
      :type =>"create",
      :msg => params[:msg],
      :save_file=> save_file.new_controller_data,
      :all_tags => Tag.all.map{|tag| tag.controller_data}.to_a,
      :file_entity_name => file_entity.original,
      :file_entity_type => file_entity.mime,
      :cancel_path => admin_save_files_path,
      :create_path => admin_save_files_path,
      :file_entity_id => file_entity.id
    }

  end

  def create
    save_file = SaveFile.new(create_save_file_params)
    if save_file.save
      redirect_to admin_save_files_path
    end
  end

  def edit
    save_file = SaveFile.find(params[:id])
    @component_name = 'EditSaveFilePage'
    @component_data = {
      :type =>"update",
      :msg => params[:msg],
      :save_file=> save_file.new_controller_data,
      :all_tags => Tag.all.map{|tag| tag.controller_data}.to_a,
      :file_entity_name => save_file.file_entity.original,
      :file_entity_type => save_file.file_entity.mime,
      :update_path => admin_save_file_path(save_file),
      :cancel_path => admin_save_files_path,
      :file_entity_id => save_file.file_entity.id
    }

  end

  def update
    save_file = SaveFile.find(params[:id])
    if save_file.update(save_file_params)
      redirect_to admin_save_files_path
    else
      render json: "保存出错"
    end
  end

  def destroy
    save_file = SaveFile.find(params[:id])
    save_file.destroy
    redirect_to admin_save_files_path
  end

  def antd_check_uniq
    file = SaveFile.where(:name => params[:name]).first
    if file.present?&&file.id.to_s!=params[:id]
        render json: {"msg": "必须唯一"}
    else
      render json: {"msg": "成功"}
    end
  end

  def antd_check_name_present
    if params[:name] == ""
      render json: {"msg": "成功"}
    elsif !SaveFile.where(:name => params[:name]).present?
      render json: {"msg": "文件不存在，请输入已有自定义文件名"}
    else
      render json: {"msg": "成功"}
    end
  end

  private 
   def save_file_params
     params.require(:SaveFile).permit(:name, :tags_name => [])
   end

   def create_save_file_params
     params.require(:SaveFile).permit(:file_entity_id,:name, :tags_name => [])
   end

end