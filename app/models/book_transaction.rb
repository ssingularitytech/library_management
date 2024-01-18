class BookTransaction < ApplicationRecord
  belongs_to :book_master
  belongs_to :borrower

  scope :active_transactions, -> { where(return_date: nil)}
  scope :archived_transactions, -> { where.not(return_date: nil)}
end
