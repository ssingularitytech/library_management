class Topic < ApplicationRecord
  has_many :book_masters, dependent: :destroy
end
