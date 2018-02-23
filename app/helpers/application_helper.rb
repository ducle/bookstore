module ApplicationHelper
  def all_categories
    @all_categories ||= Category.all.includes(:parent)
    @all_categories
  end
end
