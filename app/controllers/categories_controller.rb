class CategoriesController < CmsController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_cat, only: [:edit, :update, :destroy, :show]

  def index
    @categories = Category.page(params[:page])
  end

  def show
    cat_ids = [@category.id]
    cat_ids += @category.children.pluck('id')
    @books = Book.where(category_id: cat_ids).page(params[:page])
    params[:category_id] = @category.id
  end

  def new
    @category = Category.new
  end

  def edit
  
  end

  def create
    @category = Category.new(category_param)
    if @category.save
      flash[:notice] = "Add category successfully."
      redirect_to categories_path
    else
      render :new
    end
  end

  def update
    if @category.update_attributes(category_param)
      flash[:notice] = "Update category successfully."
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = "Delete category successfully."
    else
      flash[:notice] = "Could not delete category."      
    end    
    redirect_to categories_path
  end

  private
  def category_param
    params.require(:category).permit(
      :name,
      :parent_id,
      :position
    )
  end

  def find_cat
    @category = Category.friendly.find(params[:id])
  end
end