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
            label="TAG名"
          >
          {getFieldDecorator('Tag[name]', {initialValue: @props.name})(
            <Input className="form-input" disabled=true />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="关联 FAQ"
          >
          {getFieldDecorator('Tag[faq_ids]')(
            <Select
              multiple
              placeholder="请选择或输入关联 FAQ"
              className="form-input"
            >
              {
                for i in @props.faqs
                  <Option key={i.name}>{i.name}</Option>
              }
            </Select>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="关联资料"
          >
          {getFieldDecorator('Tag[ref_ids]')(
            <Select
              multiple
              placeholder="请选择或输入关联资料"
              className="form-input"
            >
              {
                for i in @props.references
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
    jQuery.ajax
      type: 'PUT'
      url: @props.submit_url
      data: data

module.exports = EditPage = Form.create()(Page)