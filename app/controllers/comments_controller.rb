class CommentsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      @micropost.create_notification_comment(current_user, @comment.id)
      flash[:success] = "コメントしました"
      redirect_back(fallback_location: root_path)
    else
      @micropost = Micropost.find(params[:micropost_id]) 
      @comments = @micropost.comments.includes(:user)
      flash.now[:danger] = "コメントできませんでした"
      render 'microposts/show'
    end
  end
  
  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.find_by(id: params[:id])
    if @comment.user == current_user
      @comment.destroy
      flash[:success] = "コメントを削除しました。"
      redirect_to request.referrer || root_url
    else
      redirect_to root_url
    end  
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end

end
