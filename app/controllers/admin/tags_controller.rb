class Admin::TagsController < ApplicationController
  def index
    @component_name = 'TagsIndexPage'
    @component_data = {
      tags: Tag.all.map{|tag| tag.controller_data}
    }
  end
  
  def edit
    tag = Tag.find(params[:id])
    @component_name = 'EditPage'
    @component_data = {
      tags: tag.controller_data,
      faqs: Faq.all.map{|faq| faq.simple_controller_data},
      references: Reference.all.map{|tag| tag.simple_controller_data},
      submit_url: admin_tag_path(tag),
      cancel_url: admin_tags_path,
    }
  end

  def update
    tag = Tag.find(params[:id])
    tag.change_faqs(params[:Tag][:faq_ids] ||= [])
    tag.change_refs(params[:Tag][:reference_ids] ||= [])
    tag.update(name: params[:Tag][:name])
    if tag.save
      redirect_to admin_tags_path
    else
      render json: "更新失败"
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    redirect_to admin_tags_path
  end

end
