class BooksController < CmsController
  skip_before_action :authenticate_user!, only: [:show]  
  before_action :find_book, only: [:edit, :update, :destroy, :show]

  def index
    @books = Book.page(params[:page])
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  
  end

  def create
    @book = Book.new(book_param)
    if @book.save
      flash[:notice] = "Add book successfully."
      redirect_to books_path
    else
      render :new
    end
  end

  def update
    if @book.update_attributes(book_param)
      flash[:notice] = "Update book successfully."
      redirect_to books_path
    else
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:notice] = "Delete book successfully."
    else
      flash[:notice] = "Could not delete book."      
    end    
    redirect_to books_path
  end

  private
  def book_param
    params.require(:book).permit(
      :title,
      :category_id, 
      :description, 
      :price, 
      :isbn_10, 
      :isbn_13,
      :image
    )
  end


  def find_book
    @book = Book.friendly.find(params[:id])
  end
  
end