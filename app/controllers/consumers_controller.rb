class ConsumersController < ApplicationController
  before_action :find_consumer

  def show
    # @consumer = Consumer.find_by! username: params[:username]
    # @post = current_user.posts.build if logged_in?
    # @posts = @consumer.posts.paginate(page: params[:page])


    #@feed_items = @author.feed.paginate(page: params[:page]).order(created_at: :desc)

    #@problem_thread = @author.problem_threads.build
    #@problem_threads = @author.problem_threads.paginate(page: params[:page])

    #@advice_thread = @author.advice_threads.build
    #@advice_threads = @author.advice_threads.paginate(page: params[:page])

    #authorize @consumer

  end

  def following
    @title = "Following"
    #@consumer  = Consumer.find_by! id: params[:id]
    @problem_threads = @consumer.following.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def find_consumer
    @consumer = Consumer.find_by!(username: params[:username])
  end

end
