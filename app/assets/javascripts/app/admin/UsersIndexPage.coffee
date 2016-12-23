{ Table,Button } = antd

module.exports = UsersIndexPage = React.createClass
  render: ->
    columns = [
      {
        title: "用户名"
        dataIndex: "name"
      }
      {
        title: "邮箱"
        dataIndex: "email"
      }
      {
        title: "工号"
        dataIndex: "job_number"
      }
      {
        title: "所属机构"
        dataIndex: "organization_nodes"
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (record) =>
          <div>
            <Button type="primary"><a href="/admin/users/#{record}/edit">编辑</a></Button>
            <Button type="primary" data={record} onClick={@delete.bind(this,record)}>删除</Button>
          </div>
      }
    ]
    data = []
    for i in @props.users
      org_node_s = ''
      for j in i.organization_nodes
        org_node_s += "#{j.name}，"

      data.push({
        name: i.name,
        email: i.email,
        job_number: i.job_number,
        organization_nodes:org_node_s.substring(0, org_node_s.length - 1),
        id: i.id
      })


    <div className='sample-users-table'>
      <div className="admin-tag-a">
        <a className='ant-btn ant-btn-primary' href={@props.new_url}>新增用户</a>
      </div>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (data)->
    jQuery.ajax
      type: 'DELETE'
      url: "/admin/users/#{data}"
    .done (res)->
      console.log(res.message)

