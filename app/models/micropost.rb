class Micropost < ApplicationRecord
  belongs_to :user
  has_many   :comments, dependent: :destroy
  has_many   :likes, dependent: :destroy
  has_many   :iine_users, through: :likes, source: :user
  has_many   :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  mount_uploader :picture, PictureUploader
  validates :picture, presence: true
  validate :picture_size
  validates :title, presence: true, length: { maximum: 20 }

  def iine(user)
    likes.create(user_id: user.id)
  end

  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end

  def iine?(user)
    iine_users.include?(user)
  end

  def self.search(search)
    if search
      Micropost.where(['content LIKE ?', "%#{search}%"])
    else
      Micropost.all
    end
  end

  def create_notification_like_by(current_user)
    # すでにいいねされてるか検索
    temp = Notification.where([
      "visiter_id = ? and visited_id = ? and micropost_id = ? and action = ? ",
      current_user.id, user_id, id, "like",
    ])
    # いいねされていない場合のみ通知レコード作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        micropost_id: id,
        visited_id: user_id,
        action: "like"
      )
      notification.save if notification.valid?
    end
  end

  def create_notification_comment(current_user, comment_id)
    # Commentsテーブルからユーザーidだけを取得
    temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    # だれもコメントしてなかったら投稿者に通知を送る
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      micropost_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: "comment"
    )
    # 自分の投稿に対するコメントは通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "5MBより小さくしてください")
    end
  end
end
