module NotificationsHelper
  
  def notification_form(notification)
    @comment = nil
    visiter = link_to(notification.visiter.name, notification.visiter)
    your_micropost = link_to("あなたの投稿",notification.micropost)
  
    if notification.action == "follow"
      "#{visiter}があなたをフォローしました　|"
    
    elsif notification.action == "like"
      "#{visiter}が#{your_micropost}にいいね！しました　|"
      
    elsif notification.action == "comment"
      @comment = Comment.find_by(id: notification.comment_id).content
      "#{visiter}が#{your_micropost}にコメントしました　|"
      
    end
  end
  
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end  
end
