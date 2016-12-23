{ Form, Input, Button,Select } = antd

FormItem = Form.Item
Option = Select.Option

Page = React.createClass
  render: ->
    org_node_ary = []
    for org in @props.user_data.organization_nodes
      org_node_ary.push(org.id)

    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 8 },
      wrapperCol: { span: 14 },
    }
    <div className='member-new-page'>
      <div className='member-form'>
        <Form onSubmit={@submit}>
          <FormItem 
            {...formItemLayout}
            label="用户名"
          >
          {getFieldDecorator('member[name]', {
            rules: [{
              required: true, message: '请输入用户名',
            }],
            initialValue: @props.user_data.name
          })(
            <Input className="form-input" placeholder="输入用户名" />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="邮箱"
          >
          {getFieldDecorator('user[email]',{
            rules: [{
              required: true, message: '请输入邮箱',
            }],
            initialValue: @props.user_data.email
          })(
            <Input className="form-input" placeholder="输入邮箱" />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="工号"
          >
          {getFieldDecorator('member[job_number]',{
            rules: [{
              required: true, message: '请输入工号',
            }],
            initialValue: @props.user_data.job_number
          })(
            <Input className="form-input" placeholder="输入工号" />
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="所属机构"
          >
          {getFieldDecorator('member[organization_node_ids]',{initialValue: org_node_ary})(
            <Select
              tags
              placeholder="请选择所属机构"
              className="form-input"
            >
              {
                for i in [0..@props.organization_nodes.length - 1]
                  <Option key={@props.organization_nodes[i].id}>{@props.organization_nodes[i].name}</Option>
              }
            </Select>
          )}
          </FormItem>

          <FormItem 
            {...formItemLayout}
            label="密码"
          >
          {getFieldDecorator('user[password]',{
            rules: [{
              required: true, message: '请输入密码',
            }]
          })(
            <Input className="form-input" placeholder="输入密码" />
          )}
          </FormItem>

          <FormItem>
            <Button type="primary" htmlType="submit" className="form-button">
              <FaIcon type='check' /> 确定
            </Button>
            <a className='ant-btn ant-btn-primary' href="/admin/users">
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
    if data["member[organization_node_ids]"].length == 0
      data["member[organization_node_ids]"] = [""]

    if @props.user_data.name == null
      method = 'POST'
    else
      method = 'PUT'
    jQuery.ajax
      type: method
      url: @props.submit_url
      data: data

module.exports = UsersNewEditPage = Form.create()(Page)

