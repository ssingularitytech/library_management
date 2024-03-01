class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :borrower, dependent: :destroy

  # validate user phone number add errors to user object
  validate :check_phone_number
  
  def check_phone_number
    # check if any user already has the same phone number
    return errors.add(:phone, " number already exists") if User.where(phone: phone).exists?
  end
end
