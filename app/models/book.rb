class Book < ApplicationRecord
  extend FriendlyId
  include Searchable

  belongs_to :category

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than: 0}

  friendly_id :title, use: :slugged
  mount_uploader :image, ImageUploader

  def category_name
    return category.name if category
  end

  def fore_category_name
    category.ancestry_name if category
  end
end
