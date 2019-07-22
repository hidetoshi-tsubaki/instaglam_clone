class BookmarksController < ApplicationController
  before_action :authenticate_user!
  def add_bookmark
    @post = Post.includes(:user).find(params[:id])
    send_notification_by(current_user,"bookmark")
    current_user.bookmark(@post)
    render 'bookmark'
  end

  def remove_bookmark
    @post = Post.find(params[:id])
    current_user.remove_bookmark(@post)
    render 'bookmark'
  end

end
