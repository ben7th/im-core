class Admin::FaqsController < ApplicationController
  def index
    @component_name = 'FaqsIndexPage'
    @component_data = {
      faqs: Faq.all.map{|faq| faq.controller_data},
      new_url: new_admin_faq_path
    }
  end

  def new
    faq = Faq.new
    @component_name = 'NewAndEditPage'
    @component_data = {
      faqs: faq.controller_data,
      references: Reference.all.map{|ref| ref.controller_data},
      tags: Tag.all.map{|tag| tag.controller_data},
      submit_url: admin_faqs_path,
      cancel_url: admin_faqs_path,
    }
  end

  def create
    faq = Faq.new(faq_params)
    if faq.save
      redirect_to admin_faqs_path
    else
      render json: "创建数据失败"
    end
  end

  def edit
    faq = Faq.find(params[:id])
    @component_name = 'NewAndEditPage'
    @component_data = {
      faqs: faq.controller_data,
      references: Reference.all.map{|ref| ref.controller_data},
      tags: Tag.all.map{|tag| tag.controller_data},
      submit_url: admin_faq_path(faq),
      cancel_url: admin_faqs_path,
    }
  end

  def update
    faq = Faq.find(params[:id])
    faq.update(faq_params)
    if faq.save
      redirect_to admin_faqs_path
    else
      render json: "更新数据失败"
    end
  end

  def destroy
    faq = Faq.find(params[:id])
    faq.destroy
    redirect_to admin_faqs_path
  end

  # android 获取参考资料
  def get_faq_detail
    faqs = Faq.all
    faq_ary = []
    faqs.each do |faq|
      tags_str = ''
      faq.tags.each do |tag|
        tags_str += '#' + tag.name + ' '
      end
      faq_ary.push({
        question: faq.question,
        tags: tags_str,
      })
    end
    render json: {
      faqs: faq_ary,
    }
  end

  private 
   def faq_params
     params.require(:Faq).permit(:question, :answer, :tags_name => [], :reference_ids => [])
   end
end