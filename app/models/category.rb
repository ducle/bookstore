class Category < ApplicationRecord
  extend FriendlyId  
  belongs_to :parent, class_name: 'Category', foreign_key: :parent_id, optional: true
  has_many :children, class_name: 'Category', foreign_key: :parent_id
  has_many :books

  validates :name, presence: true, uniqueness: true

  scope :roots, -> { where(parent_id: nil) }

  acts_as_list scope: [:parent_id]
  friendly_id :ancestry_name, use: :slugged

  def parent_name
    return parent.name if parent
  end

  def ancestry_name
    [parent_name, name].compact.join(' > ')
  end
end
