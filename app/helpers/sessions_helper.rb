module SessionsHelper
    def sign_in(user)
      session[:user_id] = user.id.to_s
    end

    def current_user
      @current_user ||= User.where(id: session[:user_id]).first unless session[:user_id].blank?
    end

    def user_signed_in?
      !!current_user
    end

    def sign_out(resource_or_scope=nil)
      session.delete(:user_id)
      @current_user = nil
    end
  end