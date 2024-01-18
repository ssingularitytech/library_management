class BorrowersController < ApplicationController

  def index
    @borrowers = Borrower.includes(:user).paginate(page: params[:page], per_page: 30)
  end

  def show
    @borrower = Borrower.includes(:user).find(params[:id])
  end
end
