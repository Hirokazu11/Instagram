class LikesController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.iine(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @micropost = Like.find(params[:id]).micropost
    @micropost.uniine(current_user)
    redirect_back(fallback_location: root_path)
  end

end
