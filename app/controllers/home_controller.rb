class HomeController < ApplicationController
  def index
    @books = Book.page 1
  end

  def search
    @result = Book.search(params).page(params[:page])
    @books = @result.records
  end
end