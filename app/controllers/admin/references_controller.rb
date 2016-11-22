class Admin::ReferencesController < ApplicationController
  def index
    @component_name = 'ReferencesIndexPage'
    @component_data = {
      references: Reference.all.map{|ref| ref.controller_data},
      new_url: new_admin_reference_path
    }
  end
  
  def new
    reference = Reference.new
    @component_name = 'RefNewEditPage'
    @component_data = {
      references: reference.display_data,
      tags: Tag.all.map { |tag| tag.controller_data },
      submit_url: admin_references_path,
      cancel_url: admin_references_path,
    }
  end

  def create
    reference = Reference.new(reference_params)
    if reference.save
      redirect_to admin_references_path
    else
      render :json => "保存数据失败"
    end
  end

  def edit
    reference = Reference.find(params[:id])
    @component_name = 'RefNewEditPage'
    @component_data = {
      references: reference.display_data,
      tags: Tag.all.map { |tag| tag.controller_data },
      submit_url: admin_reference_path(reference),
      cancel_url: admin_references_path,
    }
  end

  def update
    reference = Reference.find(params[:id])
    reference.update(reference_params)
    if reference.save
      redirect_to admin_references_path
    else
      render :json => "修改失败"
    end
  end

  def destroy
    reference = Reference.find(params[:id])
    reference.destroy
    redirect_to admin_references_path
  end

  private
    def reference_params
      params.require(:References).permit(:name, :describe, :kind, :tags_name => [])
    end

end