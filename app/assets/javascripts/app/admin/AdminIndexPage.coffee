{ Card, Col, Row }= antd

module.exports = AdminIndexPage = React.createClass
  render: ->
    <div className="admin-index">
      <Row className="card-row">
        <Col span="6">
          <Card className="card-col" title={<a href={@props.user.path}>用户管理</a>} bordered={false}>{@props.user.count}个用户</Card>
        </Col>
        <Col span="6">
          <Card className="card-col" title={<a href={@props.organization.path}>机构管理</a>} bordered={false}>{@props.organization.count}个机构</Card>
        </Col>
        <Col span="6">
          <Card className="card-col" title={<a href={@props.faq.path}>FAQ 管理</a>} bordered={false}>{@props.faq.count}个FAQ</Card>
        </Col>
        <Col span="6">
          <Card className="card-col" title={<a href={@props.reference.path}>参考资料管理</a>} bordered={false}>{@props.reference.count}个参考资料</Card>
        </Col>
        <Col span="6">
          <Card className="card-col" title={<a href={@props.tag.path}>TAG 管理</a>} bordered={false}>{@props.tag.count}个TAG</Card>
        </Col>
        <Col span="6">
          <Card className="card-col" title={<a href={@props.question.path}>测试题管理</a>} bordered={false}>{@props.question.count}个测试题</Card>
        </Col>
        <Col span="6">
          <Card className="card-col" title={<a href={@props.file.path}>文件管理</a>} bordered={false}>{@props.file.count}个文件</Card>
        </Col>
      </Row>
    </div>