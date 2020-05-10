class Micropost < ApplicationRecord
  belongs_to :user
  has_many   :likes, dependent: :destroy
  has_many   :iine_users, through: :likes, source: :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  mount_uploader :picture, PictureUploader
  validate :picture_size
  
  def iine(user)
    self.likes.create(user_id: user.id)
  end
  
  def uniine(user)
    self.likes.find_by(user_id: user.id).destroy
  end
  
  def iine?(user)
   self.iine_users.include?(user)
  end  
  
  private
    
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MBより小さくしてください")
      end
    end
end
