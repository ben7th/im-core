{ Form, Input, Button,Select } = antd

FormItem = Form.Item
Option = Select.Option

Page = React.createClass
  render: ->
    ref_ary = []
    tag_ary = []
    for i in @props.faqs.references
      ref_ary.push(i.id)

    for j in @props.faqs.tags
      tag_ary.push(j.name)

    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 3 },
    }
    <div className='user-new-page'>
      <div className='user-form'>
        <Form onSubmit={@submit}>
          <FormItem 
            {...formItemLayout}
            label="问题"
          >
          {getFieldDecorator('Faq[question]', {
            rules: [{
              required: true, message: '请输入问题',
            }],
            initialValue: @props.faqs.question
          })(
            <Input className="form-textarea" placeholder="输入问题" type="textarea" rows={6}/>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="解答"
          >
          {getFieldDecorator('Faq[answer]', {
            rules: [{
              required: true, message: '请输入解答',
            }],
            initialValue: @props.faqs.answer
          })(
            <Input className="form-textarea" placeholder="输入答案" type="textarea" rows={6} />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="参考资料"
          >
          {getFieldDecorator('Faq[reference_ids]', {initialValue: ref_ary})(
            <Select
              multiple
              placeholder="请选择或输入参考资料"
              className="form-input"
            >
              {
                for i in @props.references
                  <Option key={i.id}>{i.name}</Option>
              }
            </Select>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="关键词"
          >
          {getFieldDecorator('Faq[tags_name]', {initialValue: tag_ary})(
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
    this.props.form.validateFields (err, values)->
      if !err
        console.log('Received values of form: ', values)
        
    data = @props.form.getFieldsValue()
    if @props.faqs.question == null
      jQuery.ajax
        type: 'POST'
        url: @props.submit_url
        data: data
    else
      jQuery.ajax
        type: 'PUT'
        url: @props.submit_url
        data: data

module.exports = NewAndEditPage = Form.create()(Page)