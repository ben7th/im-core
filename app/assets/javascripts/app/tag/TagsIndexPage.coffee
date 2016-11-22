{ Table } = antd

module.exports = TagsIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "TAG名"
        dataIndex: "name"
      }
      {
        title: "TAG 关联 FAQ"
        dataIndex: "faqs"
      }
      {
        title: "TAG 关联参考资料"
        dataIndex: "references"
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (record) =>
          <div>
            <a className='ant-btn ant-btn-primary' href="/admin/tags/#{record}/edit">
              编辑
            </a>
            <a className='ant-btn ant-btn-primary' href="#" onClick={@delete.bind(this, record)}>
              删除
            </a>
          </div>
      }
    ]

    data = @props.tags


    <div className='sample-tags-table'>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (id)->
    jQuery.ajax
      type: 'DELETE'
      url: "/admin/tags/#{id}"
    .success (msg)->
      console.log "删除成功"
    .error (msg)->
      console.log "删除失败"