require 'open-uri'
class BookMaster < ApplicationRecord
  belongs_to :topic, optional: true
  has_many :book_transactions, dependent: :destroy
  has_many :borrowers, through: :book_transactions, source: :borrower
  has_many :users, through: :borrowers, source: :user

  validates :total_qty, numericality: { greater_than_or_equal_to: 0 }
  validates :topic, presence: true

  has_one_attached :serial_number_image


  scope :active_borrowers, -> { joins(:book_transactions).where(book_transactions: {return_date: nil}).distinct }
  scope :available, -> { left_outer_joins(:book_transactions).where(book_transactions: {return_date: nil}).or(BookMaster.left_outer_joins(:book_transactions).where(book_transactions: { id: nil })).distinct }
  scope :inactive_borrowers, -> { joins(:book_transactions).where.not(book_transactions: {return_date: nil}).distinct }

  before_create :geneate_barcode_number

  def borrowed?
    book_transactions.where(return_date: nil).count > total_qty
  end

  def geneate_barcode_number
    return if serial_number.present?
    self.serial_number = SecureRandom.hex(8)
  end

  def issue_book(user_id)
    puts "Total qty: #{total_qty}"
    puts "Borrowed qty: #{borrowed_book_qty}"
    puts "Available qty: #{available_book_qty}"
    return nil if available_book_qty <= 0

    borrower = Borrower.find_by(user_id: user_id)
    if borrower
      # Create and return the book_transaction object
      book_transactions.create(borrower_id: borrower.id, borrow_date: Time.now)
    else
      # Return nil if borrower is not found
      nil
    end
  end

  # method to return book take borrower_id as argument
  def return_book(user_id)
    borrower = Borrower.find_by(user_id: user_id)
    book_transaction = book_transactions.where(borrower_id: borrower.id, return_date: nil).first
    book_transaction.update(return_date: Time.now) if book_transaction
  end

  def available_book_qty
    total_qty - borrowed_book_qty
  end

  def borrowed_book_qty
    book_transactions.where(return_date: nil).count
  end

  after_create :attach_barcode_image

  def attach_barcode_image
    self.serial_number_image.attach(io: URI.open("https://barcodeapi.org/api/auto/#{self.serial_number}"), filename: "book-#{self.serial_number}.jpg")
  end
end
