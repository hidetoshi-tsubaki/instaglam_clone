class PagesController < ApplicationController
  before_action :authenticate_user! ,only: [:feed,:all_posts]
  before_action :correct_user_page, only: [:feed, :all_posts]
  def feed
    @user = User.find(params[:id])
    @comment = Comment.new
    @posts = Post.includes(:user,:comments).where("user_id IN (?)",@user.following_ids).recent.page(params[:page]).per(15)
  end

  def all_posts
    @user = User.find(params[:id])
    @comment = Comment.new
    @posts = Post.all.recent.page(params[:page]).per(15)
    render 'feed'
  end

  def top
  end

  private
    def correct_user_page
      user = User.find(params[:id])
      unless current_user.id == user.id
        redirect_to new_user_session_path
      end
    end
  
end
