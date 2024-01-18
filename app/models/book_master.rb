class BookMaster < ApplicationRecord
  belongs_to :topic, optional: true
  has_many :book_transactions, dependent: :destroy
  has_many :borrowers, through: :book_transactions, source: :borrower
  has_many :users, through: :borrowers, source: :user


  scope :active_borrowers, -> { joins(:book_transactions).where(book_transactions: {return_date: nil}).distinct }
  scope :available, -> { joins(:book_transactions).where(book_transactions: {return_date: nil}).distinct }
  scope :inactive_borrowers, -> { joins(:book_transactions).where.not(book_transactions: {return_date: nil}).distinct }

  before_create :geneate_barcode_number

  def borrowed?
    book_transactions.where(return_date: nil).any?
  end

  def geneate_barcode_number
    self.serial_number = SecureRandom.hex(8)
  end

  def issue_book(user_id)
    borrower = Borrower.find_by(user_id: user_id)
    book_transactions.create(borrower_id: borrower.id, borrow_date: Time.now)
  end

  # method to return book take borrower_id as argument
  def return_book(user_id)
    borrower = Borrower.find_by(user_id: user_id)
    book_transaction = book_transactions.where(borrower_id: borrower.id, return_date: nil).first
    book_transaction.update(return_date: Time.now)
  end
end
