require 'open-uri'
class BookMaster < ApplicationRecord
  belongs_to :topic, optional: true
  has_many :book_transactions, dependent: :destroy
  has_many :borrowers, through: :book_transactions, source: :borrower
  has_many :users, through: :borrowers, source: :user

  has_one_attached :serial_number_image


  scope :active_borrowers, -> { joins(:book_transactions).where(book_transactions: {return_date: nil}).distinct }
  scope :available, -> { left_outer_joins(:book_transactions).where(book_transactions: {return_date: nil}).distinct }
  scope :inactive_borrowers, -> { joins(:book_transactions).where.not(book_transactions: {return_date: nil}).distinct }

  before_create :geneate_barcode_number

  def borrowed?
    book_transactions.where(return_date: nil).any?
  end

  def geneate_barcode_number
    return if serial_number.present?
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

  after_create :attach_barcode_image

  def attach_barcode_image
    self.serial_number_image.attach(io: URI.open("https://barcodeapi.org/api/auto/#{self.serial_number}"), filename: "book-#{self.serial_number}.jpg")
  end
end
