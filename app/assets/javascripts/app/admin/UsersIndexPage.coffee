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

    data = @props.users

    <div className='sample-users-table'>
      <Button type="primary"><a href={@props.new_url}>新增用户</a></Button>
      <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>

  delete: (data)->
    jQuery.ajax
      type: 'DELETE'
      url: "/admin/users/#{data}"
    .done (res)->
      console.log(res.message)

