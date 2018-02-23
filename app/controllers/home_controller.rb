class HomeController < ApplicationController
  def index
  end

  def search
    @result = Book.search(params).page(params[:page])
  end
end