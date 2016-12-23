{ Form, Input, Button,Select } = antd

FormItem = Form.Item
Option = Select.Option

Page = React.createClass
  render: ->
    tag_ary = []
    for tag in @props.references.tags
      tag_ary.push(tag.name)

    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 3 },
    }
    <div className='user-new-page'>
      <div className='user-form'>
        <Form onSubmit={@submit}>
          <FormItem 
            {...formItemLayout}
            label="资料名"
          >
          {getFieldDecorator('References[name]', {
            rules: [{
              required: true, message: '请输入资料名',
            }],
            initialValue: @props.references.name
          })(
            <Input className="form-input" placeholder="输入资料名" />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="资料描述"
          >
          {getFieldDecorator('References[describe]', {initialValue: @props.references.describe})(
            <Input className="form-textarea" placeholder="输入资料描述" type="textarea" rows={6} />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="类型"
          >
          {getFieldDecorator('References[kind]', {
            rules: [{
              required: true, message: '请输入类型',
            }],
            initialValue: @props.references.kind
          })(
            <Select
              placeholder="请选择或输入类型"
              className="form-input"
            >
              {
                for i in @props.references.all_kind
                  <Option key={i}>{i}</Option>
              }
            </Select>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="关键词"
          >
          {getFieldDecorator('References[tags_name]', {initialValue: tag_ary})(
            <Select
              tags
              placeholder="请选择或输入关键词"
              className="form-input"
            >
              {
                for i in @props.tags
                  <Option key={i.name}>{i.name}</Option>
              }
            </Select>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="引用文件"
          >
          {getFieldDecorator('References[reference_file_name]', {
            rules: [{
              validator: this.check_present,
            }],
            initialValue: @props.references.reference_file_name
          })(
            <Input className="form-input" placeholder="输入引用文件名" />
          )}
          </FormItem>

          <FormItem>
            <Button type="primary" htmlType="submit" className="form-button">
              <FaIcon type='check' /> 确定
            </Button>
            <a className='ant-btn ant-btn-primary' href={@props.cancel_url}>
              <FaIcon type='close' /> 取消
            </a>
          </FormItem>

        </Form>
      </div>
    </div>

  check_present: (rule, value, callback)-> 

    params = {"name" : value}
    jQuery.ajax
      type: 'POST'
      url: "/admin/files/antd_check_name_present"
      data: params 
    .success (msg) =>
      if msg["msg"] != "成功"
        callback(msg["msg"])

  submit: (evt)->
    evt.preventDefault()
    this.props.form.validateFields (err, values)->
      if !err
        console.log('Received values of form: ', values)

    data = @props.form.getFieldsValue()
    if @props.references.name == null
      jQuery.ajax
        type: 'POST'
        url: @props.submit_url
        data: data
    else
      jQuery.ajax
        type: 'PUT'
        url: @props.submit_url
        data: data

module.exports = RefNewEditPage = Form.create()(Page)