class BookTransactionsController < ApplicationController
  def index
    @book_transactions = BookTransaction.includes(:book_master, :borrower).paginate(page: params[:page], per_page: 30)
  end

  def active
    @book_transactions = BookTransaction.includes(:book_master, :borrower).active_transactions.paginate(page: params[:page], per_page: 30)
    render :index
  end

  def archived
    @book_transactions = BookTransaction.includes(:book_master, :borrower).archived_transactions.paginate(page: params[:page], per_page: 30)
    render :index
  end

  def show
    @book_transaction = BookTransaction.find(params[:id])
  end

  def return_book
    @book_transaction = BookTransaction.includes(:book_master, :borrower).find(params[:id])
    @book_master = @book_transaction.book_master
    @borrower = @book_transaction.borrower
    @book_master.return_book(@borrower.user_id)

    redirect_to @book_transaction, notice: "Book returned successfully"
  end

  def new
    @book_transaction = BookTransaction.new

    if params[:book_master_id].present?
      @book_master = BookMaster.available.find_by(id: params[:book_master_id])

      if @book_master.blank?
        redirect_to new_book_transaction_path, alert: "Book not available"
        return
      end
      @book_transaction.book_master_id = @book_master.id
    end

    # respond_to do |format|
    #   format.html
    #   format.turbo_stream { render turbo_stream: turbo_stream.replace(@book_transaction, partial: "book_transactions/form", locals: { book_transaction: @book_transaction }) }
    # end

  end

  def create
    @book_master = BookMaster.find(params[:book_transaction][:book_master_id])
    @borrower = Borrower.find_by(id: params[:book_transaction][:borrower_id])
    @book_transaction = @book_master.issue_book(@borrower.user_id)

    redirect_to @book_transaction, notice: "Book issued successfully"
  end
end
