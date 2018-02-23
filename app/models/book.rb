class Book < ApplicationRecord
  # extend FriendlyId
  include Searchable

  belongs_to :category

  validates :title, presence: true
  validates :isbn_10, presence: true
  validates :isbn_13, presence: true
  validates :price, presence: true, numericality: { greater_than: 0}

  # friendly_id :title, use: :slugged
  mount_uploader :image, ImageUploader

  def category_name
    return category.name if category
  end

  def fore_category_name
    category.ancestry_name if category
  end

  def thumb_url
    image.thumb.url if image
  end
end
