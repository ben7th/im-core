#= require libs
#= require react-adapter
#= require antd-adapter
#= require file_part_upload/uploader 

# utils
require 'utils/_index'

# layouts
require 'layouts/_index'

# -----------------------------




# app components
window.AppComponents = {}
register = (component, displayName=null)->
  component.displayName = displayName || component.displayName
  window.AppComponents[component.displayName] = component

# auth
register (require 'app/auth/AuthSignInPage'), 'AuthSignInPage'

# organization
register require 'app/OrganizationsTreesPage'
register require 'app/OrganizationTreePage'
register require 'app/OrganizationNodeShow'

register require 'app/admin/organization/ListPage'
register require 'app/admin/organization/TreeShowPage'

register (require 'app/admin/organization/CreateUpdatePage'), 'CreateUpdatePage'

# chatroom
register require 'app/chat/ChatCharAvatar'
register require 'app/chat/ChatPageOrganizationTree'
register require 'app/chat/ChatPageChatRoom' 
register require 'app/chat/ChatPageCurrentUser'
register require 'app/chat/ChatPage'

# admin/user 
register require 'app/admin/UsersIndexPage'
register (require 'app/admin/UsersNewEditPage'), 'UsersNewEditPage'

# FAQ
register (require 'app/admin/faq/NewAndEditPage'), 'NewAndEditPage'
register require 'app/admin/faq/FaqsIndexPage'

# Reference(参考资料)
register (require 'app/admin/reference/RefNewEditPage'), 'RefNewEditPage'
register require 'app/admin/reference/ReferencesIndexPage'

# 标签
register (require 'app/admin/tag/EditPage'), 'EditPage'
register require 'app/admin/tag/TagsIndexPage'


#admin/index
register require 'app/admin/AdminIndexPage'

# 测试题管理  
register require 'app/admin/question/QuestionIndexPage'
register (require 'app/admin/question/SingleEditPage'), 'SingleEditPage'
register (require 'app/admin/question/MultiEditPage'), 'MultiEditPage'
register (require 'app/admin/question/BoolEditPage'), 'BoolEditPage'

# 保存文件
register require 'app/admin/save_file/UploadPage'
register require 'app/admin/save_file/IndexSaveFilePage'
register (require 'app/admin/save_file/EditSaveFilePage'), 'EditSaveFilePage'
