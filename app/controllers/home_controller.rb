class HomeController < ApplicationController
  def index
    @total_books = BookMaster.count
    @total_borrowers = Borrower.count
    @books_currently_borrowed = BookTransaction.active_transactions.count
    @recently_added_books = BookMaster.order(created_at: :desc).limit(5).count
    @recent_transactions = BookTransaction.order(created_at: :desc).limit(5)
    @overdue_books = BookMaster.joins(:book_transactions).where('book_transactions.return_date < ?', Date.today)
    @popular_books = BookMaster.joins(:book_transactions).group(:id).order('COUNT(book_transactions.id) DESC').limit(5)
    @top_borrowers = Borrower.joins(:book_transactions).group(:id).order('COUNT(book_transactions.id) DESC').limit(5)

  end
end
