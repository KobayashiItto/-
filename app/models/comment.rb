class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post


  validates :overall, presence: true

  mount_uploader :image, ImageUploader
end
