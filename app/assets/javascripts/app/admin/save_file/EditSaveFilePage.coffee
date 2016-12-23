{ Form, Input, Button,message,Select } = antd

FormItem = Form.Item
Option = Select.Option

Page = React.createClass
  componentWillMount: ->
    if @props.msg
      message.info(@props.msg)  

  check_uniq: (rule, value, callback)-> 

    if value == ""
       callback('不为空')
    else
      params = {"name" : value ,"id":@props.save_file.id}
      jQuery.ajax
        type: 'POST'
        url: "/admin/files/antd_check_uniq"
        data: params 
      .success (msg) =>
        if msg["msg"] != "成功"
          callback(msg["msg"])

  render: ->
    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 5 },
    }
   
    <div className='save-file-edit-page'>
      <div className='save-file-form'>
        <Form onSubmit={@submit}>

          <div>
          <p>文件名:</p>
          <p>{@props.file_entity_name}</p>
          </div>
          
          <div>
          <p>文件类型:</p>
          <p>{@props.file_entity_type}</p>
          </div>

          <FormItem 
            {...formItemLayout}
            label="自定义文件名"
          >
          {getFieldDecorator('SaveFile[name]',{
            rules: [{
              validator: this.check_uniq,
            }],
            initialValue: @props.save_file.name}           
          )(
            <Input className="form-input" placeholder="请输入自定义文件名" />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
          >
          {getFieldDecorator('SaveFile[file_entity_id]',{
            initialValue: @props.file_entity_id.$oid}           
          )(
            <Input style={{display:"none"}}/>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="关键词"
          >
          {getFieldDecorator('SaveFile[tags_name]', {initialValue: @props.save_file.tags_name_ary})(
            <Select
              tags
              placeholder="请选择或输入关键词"
              className="form-input"
            >
              {
                for tag in @props.all_tags
                  <Option key={tag.name}>{tag.name}</Option>    
              }
            </Select>
          )}
          </FormItem>


          <FormItem>
            <Button type="primary" htmlType="submit" className="form-button">
              <FaIcon type='check' /> 确定
            </Button>
            <a className='ant-btn ant-btn-primary' href={@props.cancel_path}>
              <FaIcon type='close' /> 取消
            </a>
          </FormItem>

        </Form>
      </div>
    </div>

  submit:(evt)->
    evt.preventDefault()
    
    if @props.type == "update"
      form_data = @props.form.getFieldsValue()
      jQuery.ajax
          type: 'PUT'
          url: @props.update_path
          data: form_data
    else
      form_data = @props.form.getFieldsValue()
      console.log form_data
      jQuery.ajax
          type: 'POST'
          url: @props.create_path
          data: form_data


module.exports = EditSaveFilePage = Form.create()(Page)



