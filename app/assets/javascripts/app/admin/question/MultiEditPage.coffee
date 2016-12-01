{ Form, Input, Button,Select, Checkbox  } = antd

FormItem = Form.Item
Option = Select.Option
CheckboxGroup = Checkbox.Group

Page = React.createClass
  getInitialState: ()->
    check_box_count: @props.choice_count
    value: @props.questions.answer["corrects"] || []
    input_value_ary: []
    check_box_checked: []

  # 设置初始 input 值
  initial_random_ary: ()->
    temp_ary = []
    if @props.questions.content != null
      temp_ary = @props.questions.answer["choices"]
    else
      for n in [1..@state.check_box_count]
        temp_ary.push({
          id: @random_string(8),
          text: ""
        })
      
    temp_ary
  
  componentWillMount:->
    @setState
      input_value_ary: @initial_random_ary()

  render: ->
    { getFieldDecorator } = @props.form
    formItemLayout = {
      labelCol: { span: 2 },
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
            label="类型"
          >
          {getFieldDecorator('Questions[kind]', {
            rules: [{
              required: true, message: '请输入类型',
            }],
            initialValue: "多选"
          })(
            <Input className="form-input" disabled=true />
          )}
          </FormItem>

          <FormItem 
            {...tailFormItemLayout}
          >
          {getFieldDecorator('Questions[answer]')(
            <div>              
              {
                if  @props.questions.content != null
                  for i in [1..@state.check_box_count]
                    if @props.questions.answer["choices"][i - 1].id in @props.questions.answer["corrects"]
                      <Checkbox className="form-textarea" onChange={@on_change} key={@props.questions.answer["choices"][i - 1].id} defaultChecked={true} value={@props.questions.answer["choices"][i - 1].id}>
                        <Input className="form-check-box-input" placeholder="请输入选项内容" id={@props.questions.answer["choices"][i - 1].id} type="textarea" rows={5} onBlur={@input_on_change} 
                          defaultValue={@props.questions.answer["choices"][i - 1].text}/>
                        <a href="javascript:;" onClick={@delete_check_box.bind(this, @props.questions.answer["choices"][i - 1].id)}>删除选项</a>
                      </Checkbox>
                    else
                      <Checkbox className="form-textarea" onChange={@on_change} key={@props.questions.answer["choices"][i - 1].id} value={@props.questions.answer["choices"][i - 1].id}>
                        <Input className="form-check-box-input" placeholder="请输入选项内容" id={@props.questions.answer["choices"][i - 1].id} type="textarea" rows={5} onBlur={@input_on_change} 
                          defaultValue={@props.questions.answer["choices"][i - 1].text}/>
                        <a href="javascript:;" onClick={@delete_check_box.bind(this, @props.questions.answer["choices"][i - 1].id)}>删除选项</a>
                      </Checkbox>
                else
                  for i in [1..@state.check_box_count]
                    <Checkbox className="form-textarea" onChange={@on_change} key={@state.input_value_ary[i - 1].id} value={@state.input_value_ary[i - 1].id}>
                      <Input className="form-check-box-input" placeholder="请输入选项内容" id={@state.input_value_ary[i - 1].id} type="textarea" rows={5} onBlur={@input_on_change} defaultValue={@state.input_value_ary[i - 1].text}/>
                      <a href="javascript:;" onClick={@delete_check_box.bind(this, @state.input_value_ary[i - 1].id)}>删除选项</a>
                    </Checkbox>
              }
            </div>
          )}
          </FormItem>

          <FormItem 
            {...tailFormItemLayout}
          >
             <a className='ant-btn ant-btn-primary' href="javascript:;" onClick={@add_check_box.bind(null, this)}>增加选项</a>
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

    if data["Questions[kind]"] == "多选"
      data["Questions[kind]"] = "multi_choice"

        # 当修改选项时
    if @state.input_value_ary.length >= 1
      checked_correct = ''
      if @state.check_box_checked.length == 0 && @props.questions.content != null
        checked_correct = @props.questions.answer.corrects
      else
        checked_correct = @state.check_box_checked

      data["Questions[answer]"] = {
        choices: @state.input_value_ary
        corrects: checked_correct
      }

    method = ''
    if @props.questions.content == null
      method = "POST"
    else
      method = "PUT"

    alarm  = ''
    choice_text_ary = []
    for c in [0...data["Questions[answer]"].choices.length]
      choice_text_ary.push(data["Questions[answer]"].choices[c].text)
      if data["Questions[answer]"].choices[c].text == ""
        alarm += "第#{c+1}个、"

    if choice_text_ary.indexOf("") != -1
      alert "请在#{alarm.substring(0, alarm.length-1)}选项中输入内容"
    else if data["Questions[answer]"].corrects.length < 2
      alert "请选择2个以上的正确答案"
    else
      json_string = JSON.stringify data
      jQuery.ajax
        type: method,
        url: @props.submit_url,
        data: 
          "json_string": json_string

  random_string: (len)->
    len = len || 8
    # 去掉了容易混淆的字符 oO0, Ll, 9gq, Vv, Uu, I1
    chars = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678"
    max_size = chars.length
    random_id = ''
    for s in [0...len]
      random_id += chars.charAt(Math.floor(Math.random()*max_size))
    random_id


  on_change: (e)->
    corrects = @state.value
    if e.target.value in corrects
      for i in [0..corrects.length - 1]
        if corrects[i] == e.target.value
          add_corrects = corrects.slice(0,i).concat(corrects.slice(i + 1))
    else
      add_corrects = corrects.concat(e.target.value)

    @setState
      check_box_checked: add_corrects
      value: add_corrects

  add_check_box: ()->
    temp_ary = @state.input_value_ary
    temp_ary.push({id: @random_string(8), text: ""})
    @setState
      check_box_count: @state.check_box_count + 1
      input_value_ary: temp_ary

  delete_check_box: (key_num)->
    temp_ary = @state.input_value_ary
    corrects_ary = @props.questions.answer.corrects
    if @props.questions.content != null
      for j in [0...corrects_ary.length]
        if corrects_ary[j] == key_num
          corrects_ary.splice(j, 1)
          
    if @state.check_box_count > 1
      for i in [0...temp_ary.length]
        if temp_ary[i].id == key_num
          temp_ary.splice(i, 1)
          break
      data = @state.check_box_count - 1
      @setState
        check_box_checked: corrects_ary
        check_box_count: data
        input_value_ary: temp_ary

  # 保存 input 中的值
  input_on_change: (e)->
    if @props.questions.content != null
      if e.target.value == ""
        alert "选项中不能为空，如果此选项为空则默认为不做修改。"

    data = @state.input_value_ary
    need_value_push = {id: e.target.id, text:e.target.value}
    id_ary = []
    for i in data
      id_ary.push(i.id)

    if data.length == 0 && e.target.value != "" 
      data.push(need_value_push)

    else
      if id_ary.indexOf(need_value_push.id) == -1 && e.target.value != ""
        data.push(need_value_push)

      if id_ary.indexOf(need_value_push.id) != -1 && e.target.value != ""
        for i in data 
          if need_value_push.id == i.id
            i.text = need_value_push.text

    @setState
      input_value_ary: data


module.exports = MultiEditPage = Form.create()(Page)