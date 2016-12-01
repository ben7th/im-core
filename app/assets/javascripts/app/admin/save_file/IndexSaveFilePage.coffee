{ Table,Button } = antd

module.exports = IndexSaveFilePage = React.createClass
  delete: (data)->
    jQuery.ajax
      type: 'DELETE'
      url: "/admin/files/#{data}"


  render: ->
    columns = [
      {
        title: "文件名"
        dataIndex: "raw_name"
      }
      {
        title: "自定义名称"
        dataIndex: "name"
      }
      {
        title: "文件类型"
        dataIndex: "type"
      }
      {
        title: "关键词"
        dataIndex: "tags"
      }
      {
        title: "操作"
        dataIndex: "id"
        render: (id) =>
          <div>
            <Button type="primary"><a href="/admin/files/#{id}/edit">编辑</a></Button>
            <Button type="primary" data={id} onClick={@delete.bind(this,id)}>删除</Button>
          </div>
      }
    ]

    data = []
    for save_file in @props.save_files
      tags_name = ""
      for tag in save_file.tags_name_ary
        tags_name += "#{tag},"

      data.push({
        "name":save_file["name"],
        "raw_name":save_file["file_entity_name"],
        "type":save_file["file_entity_type"],
        "tags":tags_name.substring(0, tags_name.length - 1),
        "id":save_file["id"]
        })


    <div className='sample-users-table'>
        <div className="admin-tag-a">
          <a className='ant-btn ant-btn-primary' href={@props.upload_path}>上传文件</a>
        </div>
        <Table columns={columns} dataSource={data} pagination={false} size='small' />
    </div>