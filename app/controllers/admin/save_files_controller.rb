class Admin::SaveFilesController < ApplicationController
  def index
    @component_name = 'IndexSaveFilePage'
    @component_data = {
      upload_path: upload_admin_save_files_path,
      save_files: SaveFile.all.map{|save_file| save_file.controller_data}.to_a
    }
  end

  def upload
    @component_name = 'UploadPage'
    @component_data = {
      data: FilePartUpload.get_dom_data,
      create_path: admin_save_files_path,
      cancel_path: admin_save_files_path,
    }
  end

  def create
    save_file = SaveFile.create(:file_entity_id => params[:id])
    redirect_to "#{edit_admin_save_file_path(save_file)}?msg=上传成功 请修改文件信息"
  end

  def edit
    save_file = SaveFile.find(params[:id])
    @component_name = 'EditSaveFilePage'
    @component_data = {
      :msg => params[:msg],
      :save_file=> save_file.controller_data,
      :all_tags => Tag.all.map{|tag| tag.controller_data}.to_a,
      :file_entity_name => save_file.file_entity.original,
      :file_entity_type => save_file.file_entity.mime,
      :update_path => admin_save_file_path(save_file),
      :cancel_path => admin_save_files_path,
    }

  end

  def update
    save_file = SaveFile.find(params[:id])
    if save_file.update(save_file_params)
      redirect_to admin_save_files_path
    end
  end

  def destroy
    save_file = SaveFile.find(params[:id])
    save_file.destroy
    redirect_to admin_save_files_path
  end

  private 
   def save_file_params
     params.require(:SaveFile).permit(:name, :tags_name => [])
   end

end