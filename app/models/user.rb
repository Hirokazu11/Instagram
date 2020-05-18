class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable, :omniauthable
  has_many :microposts,dependent: :destroy
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
    
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,presence:true,length:{maximum:50}
  validates :user_name,presence:true,length:{maximum:10}
  VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,presence:true,length:{maximum:255},
             format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password,presence:true,length:{minimum:6},allow_nil: true
  validates :website,length:{maximum: 50}
  validates :introduction,length:{maximum: 150}
  validates :phone_number,length:{maximum: 12}
  enum gender: { man: 0, woman: 1}
  
  
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
    update_attribute(:remember_digest,User.digest(remember_token))
  end
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    update_attribute(:remember_digest,nil)
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  def follow(other_user)
    self.active_relationships.create(followed_id: other_user.id)
  end  
  
  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def following?(other_user)
    self.following.include?(other_user)
  end  
  
  def create_notification_follow_by(current_user)
    # すでにフォローされてるか検索
    temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ", 
                              current_user.id, id, "follow"])
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
      User.where(['name LIKE ?', "%#{search}%"])
    else
      User.all
    end  
  end
  
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # def self.find_for_oauth(auth)
  #   user = User.where(uid: auth.uid, provider: auth.provider).first
  #   unless user
  #     user = User.new(
  #       uid:      auth.uid,
  #       provider: auth.provider,
  #       email:    auth.info.email,
  #       password: Devise.friendly_token[0, 20]
  #     )
  #     user.save(:validate => false)
  #   end
    
  #   user
  # end
  
  private
    
    def downcase_email
      self.email = email.downcase
    end
  
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
