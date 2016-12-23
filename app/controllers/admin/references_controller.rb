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
      references: reference.controller_data,
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
      references: reference.controller_data,
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

  # android 获取参考资料
  def get_ref_detail
    references = Reference.all
    ref_ary = []
    kind = ''
    references.each do |ref|
      tags_str = ''
      ref.tags.each do |tag|
        tags_str += '#' + tag.name + ' '
      end
      if ref.reference_file_name != ""
        kind = SaveFile.where(:name => ref.reference_file_name).first.file_entity.kind
      end
      ref_ary.push({
        id:   ref.id.to_s,
        name: ref.name,
        tags: tags_str,
        kind: kind
      })
      kind = ''
    end
    render json: {
      references: ref_ary,
    }
  end

  # 获取资料中的文件用于 Android 端阅读或播放
  def fetch_ref_file
    ref         = Reference.find(params[:id])
    if ref.reference_file_name != ""
      file_entity = SaveFile.where(:name => ref.reference_file_name).first.file_entity
      case file_entity.kind
        when "video"
        render json:{
          name: ref.name,
          url: file_entity.transcoding_records.first.url,
          status:file_entity.transcoding_records.first.status.to_s,
        }
        when "pdf"
        render json:{
          name: ref.name,
          urls: file_entity.transcode_urls("jpg")
        }
        when "office"
        # 部署到公网后set status 执行jpg转换代码可以删除
        SaveFile.where(:name => ref.reference_file_name).first.file_entity.transcoding_records.first.update_status_by_code(0)
        render json:{
          name: ref.name,
          urls: file_entity.transcode_urls("jpg")
        }
      end
    end
  end

  private
    def reference_params
      params.require(:References).permit(:name, :describe, :kind, :reference_file_name, :tags_name => [])
    end

end