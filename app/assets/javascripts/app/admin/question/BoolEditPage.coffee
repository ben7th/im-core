{ Form, Input, Button, Switch  } = antd

FormItem = Form.Item

Page = React.createClass
  getInitialState: ()->
    {
      value: 1
    }

  onChange: (checkedValues)->
    console.log('checked = ', checkedValues)

  render: ->
    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 3 },
    }
    tailFormItemLayout = {
      wrapperCol: {
        offset: 2,
      },
    }
    <div className='user-new-page'>
      <div className='user-form'>
        <Form onSubmit={@submit}>
          <FormItem 
            {...formItemLayout}
            label="问题"
          >
          {getFieldDecorator('Questions[content]', {
            rules: [{
              required: true, message: '请输入问题'
            }],
            initialValue: @props.questions.content
          })(
            <Input className="form-textarea" placeholder="请输入问题" type="textarea" rows={6} />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="判断"
          >
          {getFieldDecorator('Questions[kind]', {
            rules: [{
              required: true, message: '请输入类型',
            }],
            initialValue: "判断"
          })(
            <Input className="form-input" disabled=true />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="答案对错: "
          >
          {getFieldDecorator('Questions[answer]', { 
            initialValue: @props.questions.answer 
          })(
            <Switch defaultChecked={@props.questions.answer} checkedChildren={'对'} unCheckedChildren={'错'} />
          )}
          </FormItem>

          <FormItem
            {...tailFormItemLayout}
          >
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

  submit: (evt)->
    evt.preventDefault()
    this.props.form.validateFields (err, values)->
      if !err
        console.log('Received values of form: ', values)
        
    data = @props.form.getFieldsValue()
    if data["Questions[kind]"] == "判断"
      data["Questions[kind]"] = "bool"

    if @props.questions.content == null
      jQuery.ajax
        type: 'POST'
        url: @props.submit_url
        data: data
    else
      jQuery.ajax
        type: 'PUT'
        url: @props.submit_url
        data: data

module.exports = BoolEditPage = Form.create()(Page)