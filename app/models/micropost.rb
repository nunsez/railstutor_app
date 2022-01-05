class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader

  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: 140 }

  validate :picture_size

  paginates_per 10
  # validates :user_id, presence: true

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, 'should be less than 5MB')
    end
  end
end
