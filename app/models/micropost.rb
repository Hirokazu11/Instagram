class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  mount_uploader :picture, PictureUploader
  

  private
    
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MBより小さくしてください")
      end
    end
end
