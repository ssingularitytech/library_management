class BooksController < ApplicationController
  def index
    @books = BookMaster.paginate(page: params[:page], per_page: 30)
  end

  def show
    @book = BookMaster.find(params[:id])
  end
end
