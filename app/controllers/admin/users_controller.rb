class Admin::UsersController < ApplicationController
  def index
    @component_name = 'UsersIndexPage'
    @component_data = {
      users: Member.all.map { |member|
        member.controller_data
      },
      new_url: new_admin_user_path,
    }
  end

  def new
    member = Member.new
    @component_name = 'UsersNewEditPage'
    @component_data = {
      user_data: member.controller_data,
      submit_url: admin_users_path,
      organization_nodes: OrganizationNode.all.map { |node|
        node.controller_data
      }
    }
  end

  def create
    member = Member.create(member_params)
    user = User.create(user_params)
    member.user_id = user.id.to_s
    if member.save && user.save
      redirect_to admin_users_path
    else
      render json: "新建失败"
    end
  end

  def edit
    member = Member.find(params[:id])
    @component_name = 'UsersNewEditPage'
    @component_data = {
      user_data: member.controller_data,
      submit_url: admin_user_path(member),
      organization_nodes: OrganizationNode.all.map { |node|
        node.controller_data
      }
    }
  end

  def update
    member = Member.find(params[:id])
    member.update(member_params)
    member.user.update(user_params)
    if member.save
      redirect_to admin_users_path
    else
      render json: "修改失败"
    end
  end

  def destroy
    member = Member.find(params[:id])
    member.user.destroy
    member.destroy
    redirect_to admin_users_path
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end

    def member_params
      params.require(:member).permit(:name, :job_number, :organization_node_ids => [])
    end
end