class AdminController < ApplicationController
  def index
    @component_name = 'AdminIndexPage'
    @component_data = {
      user: {
        count: User.count,
        path: admin_users_path,
      },
      organization: {
        count: OrganizationNode.count,
        path: admin_organizations_path,
      },
      faq: {
        count: Faq.count,
        path: admin_faqs_path,
      },
      reference: {
        count: Reference.count,
        path: admin_references_path,
      },
      tag: {
        count: Tag.count,
        path: admin_tags_path,
      },
      question: {
        count: Question.count,
        path: admin_questions_path,
      },
      file: {
        count: SaveFile.count,
        path: admin_save_files_path,
      },
    }
  end
end