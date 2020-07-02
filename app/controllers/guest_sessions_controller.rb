class GuestSessionsController < ApplicationController
  def create
    user = User.find_by(email: "test@example.com")
    log_in(user)
    flash[:success] = "ゲストユーザーでログインしました"
    redirect_to user
  end
end
