class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  
  def index
    @users = User.paginate(page:params[:page]).search(params[:search])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page]).search(params[:search])
    @comment = Comment.new
  end 
 
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "あなたのメールをチェックしてアカウントの認証をしてください."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end  
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end  
  
  def destroy
    User.find(params[:id]).destroy
    unless admin_user
      flash[:success] = "削除しました"
      redirect_to users_url  
    end
  end
  
  def following
    @title = "フォロー一覧"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "フォロワー一覧"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
      
  private
    
    def user_params
      params.require(:user).permit(:name,:user_name,:email,
                          :website,:introduction,:phone_number,
                          :gender,:password,:password_confirmation,)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
