class Book < ApplicationRecord
  extend FriendlyId
  
  belongs_to :category

  validates :title, presence: true

  friendly_id :title, use: :slugged
  mount_uploader :image, ImageUploader
end
