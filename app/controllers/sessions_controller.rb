class SessionsController < ApplicationController
  add_flash_types :success, :info, :warning, :danger
  def new
    
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      if user.employee
        redirect_to employee_users_url, success: "ログインしました"
      else
        redirect_to top_show_url, success: "ログインしました"
      end
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to top_show_url, success: "ログアウトしました"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end


end
