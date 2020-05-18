class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page]).search(params[:search])
    end
  end

  def terms
  end
  
  def privacypolicy
  end  
end
