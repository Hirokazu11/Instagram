class SessionsController < ApplicationController
  def new
  end
  
  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_auth(auth)
      if user.save(context: :facebook_login)
        log_in user
        flash[:success] = "Facebookログインしました"
        redirect_to user
      else
        flash.now[:danger] = "あなたのFacebookアカウントに紐づくユーザーがいません"
        render 'new'
      end
    else      
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        if user.activated?
          log_in user
          params[:session][:remember_me]=='1' ? remember(user) : forget(user)
          flash[:success] = "ログインできました"
          redirect_back_or user
        else
          message  = "アカウントが認証されてません. "
          message += "認証リンクをメールから開いてください."
          flash[:warning] = message
          redirect_to root_url
        end  
      else
        flash.now[:danger] = "入力情報が正しくないです"
        render 'new'
      end
    end  
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
