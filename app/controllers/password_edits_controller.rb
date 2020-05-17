class PasswordEditsController < ApplicationController
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.authenticated?(:password, params[:user][:current_password])
      if @user.update_attributes(user_params)          
        flash[:success] = "パスワードを変更しました"
        redirect_to @user
      else
        render 'edit'               
      end
    else
      flash[:danger] = "パスワードが間違っています"
      render 'edit'
    end  
  end
  
  private
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  
end
