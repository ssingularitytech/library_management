class Api::V1::BookMastersController < ApplicationController

  def show
    if params[:serial_number].nil?
      render json: { message: 'serial_number is missing' }, status: :bad_request
      return
    end

    @book = BookMaster.find_by(serial_number: params[:serial_number])

    if @book.nil?
      render json: { message: 'Book not found' }, status: :not_found
    else
      render json: {
        book: @book, message: "Book Found"
      }, status: :ok
    end
  end

end
