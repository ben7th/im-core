{ Table } = antd

module.exports = FaqsIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "问题"
        dataIndex: "question"
      }
      {
        title: "解答"
        dataIndex: "answer"
      }
      {
        title: "参考资料"
        dataIndex: "references"
      }
      {
        title: "关键词"
        dataIndex: "tags"
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (record) =>
          <div className="admin-option-tag-a">
            <a className='ant-btn ant-btn-primary' href="/admin/faqs/#{record}/edit">
              编辑
            </a>
            <a className='ant-btn ant-btn-primary' href="#" onClick={@delete.bind(this, record)} >
              删除
            </a>
          </div>
      }
    ]
    data = []
    for i in @props.faqs
      ref_s = ''
      tag_s = ''
      for j in i.references
        ref_s += "#{j.name},"

      for k in i.tags
        tag_s += "#{k.name},"

      data.push({
        question: i.question,
        answer: i.answer,
        references: ref_s.substring(0, ref_s.length-1),
        tags: tag_s.substring(0, tag_s.length-1),
        id: i.id
      })
    
      
    <div className='sample-faqs-table'>
      <div className="admin-tag-a">
        <a className='ant-btn ant-btn-primary' href={@props.new_url}>新增 FAQ</a>
      </div>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>


  delete: (id)->
    jQuery.ajax
      type: 'DELETE',
      url: "/admin/faqs/#{id}"
    .success (msg)->
      console.log "删除成功"
    .error (msg)->
      console.log "删除失败"