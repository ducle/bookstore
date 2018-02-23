class Book < ApplicationRecord
  extend FriendlyId
  
  belongs_to :category

  validates :title, presence: true

  friendly_id :title, use: :slugged
  mount_uploader :image, ImageUploader


  def category_name
    return category.name if category
  end
end
