class Admin::UsersController < ApplicationController
  include SessionsHelper

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
    if member.save &&  member.user.save
      redirect_to admin_users_path
    else
      render json: "修改失败"
    end
  end

  # 
  def update_user
    current_user.password = params[:password]
    current_user.member.name = params[:name]

    if current_user.save && current_user.member.save
     # 考虑验证错误时的报错信息
     render :json => {:status_code => "200" }
    end
  
  end

  def get_user_detail
    render json: {
      password: current_user.password,
      email: current_user.email,
      name: current_user.member.name,
      organizations: current_user.member.organization_nodes.map{|organization| organization.name}
    }
  end

  def destroy
    member = Member.find(params[:id])
    member.user.destroy
    member.destroy
    redirect_to admin_users_path
  end

  # android 登录验证
  def do_sign_in
    user = User.where(email: params[:email])
    if user.present? 
      if user.first.valid_password?(params[:password])
        sign_in user.first
        render json: {valid_info: "successfully" ,id: user.first.id.to_s}
      else
        render json: {valid_info: "密码错误 !"}
      end
    else
      render json: {valid_info: "用户不存在 !"}
    end
   
  end

  def do_sign_out
    sign_out current_user
    render json: {status_code: "200"}
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end

    def member_params
      params.require(:member).permit(:name, :job_number, :organization_node_ids => [])
    end
end