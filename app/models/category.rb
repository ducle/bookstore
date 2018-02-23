class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', foreign_key: :parent_id, optional: true
  has_many :children, class_name: 'Category', foreign_key: :parent_id
  has_many :books

  validates :name, presence: true, uniqueness: true

  scope :roots, -> { where(parent_id: nil) }

  acts_as_list scope: [:parent_id]

  def parent_name
    return parent.name if parent
  end
end
