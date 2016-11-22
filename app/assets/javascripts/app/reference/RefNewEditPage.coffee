{ Form, Input, Button,Select } = antd

FormItem = Form.Item
Option = Select.Option

Page = React.createClass
  render: ->
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
          {getFieldDecorator('References[name]', {initialValue: @props.references.name})(
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
          {getFieldDecorator('References[kind]')(
            <Select
              placeholder="请选择或输入类型"
              className="form-input"
            >
              {
                for i in @props.references.kind
                  <Option key={i}>{i}</Option>
              }
            </Select>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="关键词"
          >
          {getFieldDecorator('References[tags_name]')(
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

  submit: (evt)->
    evt.preventDefault()
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