{ Table, Button} = antd

module.exports = ListPage = React.createClass
  render: ->
    columns = [
      {
        title: '机构名'
        dataIndex: 'name'

      }
      {
        title: '机构编号'
        dataIndex: 'code'
      }
      {
        title: '上级机构'
        dataIndex: 'parents_name'
      }
      {
        title: '下级机构'
        dataIndex: 'children_name'
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (record) =>
          <div>
            <a className='ant-btn ant-btn-primary' href="/admin/organizations/#{record}/edit">
              编辑
            </a>
            <a className='ant-btn ant-btn-primary' onClick={@delete_relation.bind(this, record)}>
              删除
            </a>
          </div>
      }
    ]
    datas = @props.organization

    <div> 
      <a className='ant-btn ant-btn-primary' href="/admin/organizations/new">
        新增机构
      </a>
      <a className='ant-btn ant-btn-primary' href="/admin/organizations/tree_show">
        查看树状结构
      </a>
      <Table columns={columns} dataSource={datas} pagination={false}/>
    </div>

  delete_relation: (id)->
    jQuery.ajax
      url: "/admin/organizations/#{id}",
      method: "DELETE"
    .success (msg)->
      console.log msg
    .error (msg)->
      console.log msg