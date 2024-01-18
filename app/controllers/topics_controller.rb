class TopicsController < ApplicationController
  def index
    @topics = Topic.joins(:book_masters).paginate(page: params[:page], per_page: 30).select("topics.*, count(book_masters.id) as book_count").group("topics.id").order("book_count DESC")
  end

  def show
    @topic = Topic.find(params[:id])
    @books = @topic.book_masters.paginate(page: params[:page], per_page: 30)
  end
end
