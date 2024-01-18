class Borrower < ApplicationRecord
  belongs_to :user
  has_many :book_transactions, dependent: :destroy
  has_many :book_masters, through: :book_transactions, source: :book_master

  def user_name
    self.user.name
  end
end
