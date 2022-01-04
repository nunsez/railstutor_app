class Micropost < ApplicationRecord
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: 140 }

  paginates_per 10
  # validates :user_id, presence: true
end
