{ Table } = antd

module.exports = ReferencesIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "资料名"
        dataIndex: "name"
      }
      {
        title: "资料描述"
        dataIndex: "describe"
      }
      {
        title: "资料类型"
        dataIndex: "kind"
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
            <a className='ant-btn ant-btn-primary' href="/admin/references/#{record}/edit">
              编辑
            </a>
            <a className='ant-btn ant-btn-primary' href="#" onClick={@delete.bind(this, record)} >
              删除
            </a>
          </div>
      }
    ]
    data = []
    for ref in @props.references
      tag_s = ''
      for t in ref.tags
        tag_s += "#{t.name},"

      data.push({
        name: ref.name,
        describe: ref.describe,
        kind: ref.kind,
        tags: tag_s.substring(0, tag_s.length - 1),
        id: ref.id
      })

    <div className='sample-references-table'>
      <div className="admin-tag-a">
        <a className='ant-btn ant-btn-primary' href={@props.new_url}>新增参考资料</a>
      </div>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (id)->
    jQuery.ajax
      url: "/admin/references/#{id}",
      type: 'DELETE'
    .success (msg)->
      console.log "删除成功"
    .error (msg) ->
      console.log "删除失败"