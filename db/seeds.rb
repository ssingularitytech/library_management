# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if User.find_by(email: "admin@example.com").nil?
  User.create!(
    email: "admin@example.com",
    password: "password",
    password_confirmation: "password",
    name: "Admin",
    phone: "1234567890",
    address: "Admin Address",
    admin: true
  )
  100.times do |i|
    Borrower.create(
      user: User.create!(
        email: FFaker::Internet.email,
        password: "password",
        password_confirmation: "password",
        name: FFaker::Name.name,
        phone: FFaker::PhoneNumber.phone_number,
        address: FFaker::Address.street_address
      )
    )
  end
end

if Topic.count.zero?
  10.times do |i|
    Topic.create!(name: FFaker::Book.genre)
  end
end

if BookMaster.count.zero?
  1000.times do |i|
    @book_master = BookMaster.new(
      name: FFaker::Book.title,
      author: FFaker::Book.author,
      publisher: FFaker::Name.name,
      price: rand(100..1000),
      language: FFaker::Locale.language,
      topic_id: Topic.all.sample.id,
    )
    @book_master.save!
    @book_master.serial_number_image.attach(io: URI.open("https://barcodeapi.org/api/auto/#{@book_master.serial_number}"), filename: "book-#{@book_master.serial_number}.jpg")
  end
end

if BookTransaction.count.zero?
  1000.times do |i|
    book = BookMaster.all.sample
    borrower = Borrower.all.sample
    book.issue_book(borrower.user_id)
    book.return_book(borrower.user_id) if rand(1..10) > 8
  end
end

