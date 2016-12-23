{Tree, Button} = antd
TreeNode = Tree.TreeNode

module.exports = TreeShowPage = React.createClass
  make_tree: (data) -> 
    for item in data
      if item.children && item.children.length 
        <TreeNode key={item.id} title={item.name}>{@make_tree(item.children)}</TreeNode>
      else
        <TreeNode key={item.id} title={item.name}/>

  render: ->
    data = @props.organizations
    <div>
       <a className='ant-btn ant-btn-primary' href="/admin/organizations">
        返回表格
      </a>
      <Tree>   
        {@make_tree(data)}
      </Tree>
    </div>
