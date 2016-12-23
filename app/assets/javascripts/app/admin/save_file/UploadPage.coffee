{Button,Progress} = antd


module.exports = UploadPage = React.createClass
  getInitialState: ->
    percent: 0
    display_progress:false
    file_name: ""

  render: ->
    <div>
      <div>
        <a className='ant-btn ant-btn-primary upload' href='javascript:;' data-mode={@props.data["mode"]} data-qiniu-domain={@props.data["qiniu_domain"]} data-qiniu-base-path={@props.data["qiniu_base_path"]} data-qiniu-callback-url={@props.data["qiniu_callback_url"]} data-qiniu-uptoken-url={@props.data["qiniu_uptoken_url"]}>选择文件上传</a>
        
        {if @state.display_progress
          <div>
          <p> {@state.file_name} </p>
          <Progress percent={@state.percent} status="active"/>
          <span> 正在上传: </span>
          <span> {"#{@state.percent}%"} </span>
          </div>
        }
      </div>
      <a className='ant-btn ant-btn-primary' href={@props.cancel_path}>取消</a>
    </div> 


  componentDidMount: ->
    $browse_button = jQuery('.upload')

    new QiniuFilePartUploader
      browse_button: $browse_button
      dragdrop_area: null
      file_progress_class: UploadUtils.GenerateOneFileUploadProgress(@)
      max_file_size: "10mb" # 允许上传的文件大小，如果不传递该参数，默认是 "10mb"
      mime_types : [{ title : "Image files", extensions : "jpg,gif,png,mp4,pdf,doc,mkv" }] # 限制允许上传的文件类型

UploadUtils = 
   GenerateOneFileUploadProgress: (react)->
    class 
      constructor: (qiniu_uploading_file, @uploader)->
        @file = qiniu_uploading_file
        console.log @file
        react.setState
          display_progress: true
          file_name: @file.name

      # 某个文件上传进度更新时，此方法会被调用
      update: ->
        react.setState
          percent: @file.percent


      # 某个文件上传成功时，此方法会被调用
      success: (info)->
        console.log "success"       
        window.location.href = "#{react.props.new_path}?file_entity_id=#{info.file_entity_id}&msg=上传成功 请修改文件信息"


      # 某个文件上传出错时，此方法会被调用
      file_error: (up, err, err_tip)->
        console.log "file error"
        console.log up, err, err_tip

      # file entity 创建失败时，此方法会被调用
      file_entity_error: (xhr)->
        console.log "file entity error"
        console.log xhr.responseText

      # 出现全局错误时（如文件大小超限制，文件类型不对），此方法会被调用
      @uploader_error: (up, err, err_tip)->
        console.log "uploader error"
        console.log up, err, err_tip

      # 所有上传队列项处理完毕时（成功或失败），此方法会被调用
      @alldone: ->
        console.log "alldone"




