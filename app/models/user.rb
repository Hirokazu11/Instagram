class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :comments
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following,
           through: :active_relationships,
           source: :followed
  has_many :followers,
           through: :passive_relationships,
           source: :follower
  has_many :likes, dependent: :destroy
  has_many :active_notifications, class_name: "Notification",
                                  foreign_key: "visiter_id",
                                  dependent: :destroy
  has_many :passive_notifications, class_name: "Notification",
                                   foreign_key: "visited_id",
                                   dependent: :destroy

  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :user_name, presence: true, length: { maximum: 10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :website, length: { maximum: 50 }
  validates :introduction, length: { maximum: 150 }
  validates :phone_number, length: { maximum: 12 }
  enum gender: { man: 0, woman: 1 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    if remember_digest.nil?
      false
    else
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def create_notification_follow_by(current_user)
    # すでにフォローされてるか検索
    temp = Notification.where([
      "visiter_id = ? and visited_id = ? and action = ? ",
      current_user.id, id, "follow",
    ])
    # フォローされていない場合のみ通知レコード作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: "follow"
      )
      notification.save if notification.valid?
    end
  end

  def self.search(search)
    if search
      User.where(['name LIKE ? OR cooking_history LIKE ?', "%#{search}%", "%#{search}%"])
    else
      User.all
    end
  end
end
