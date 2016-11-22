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
          <div>
            <a className='ant-btn ant-btn-primary' href="/admin/faqs/#{record}/edit">
              编辑
            </a>
            <a className='ant-btn ant-btn-primary' href="#" onClick={@delete.bind(this, record)} >
              删除
            </a>
          </div>
      }
    ]
    data = @props.faqs
      
    <div className='sample-faqs-table'>
      <a className='ant-btn ant-btn-primary' href={@props.new_url}>新增 FAQ</a>
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