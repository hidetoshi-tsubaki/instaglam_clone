class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id).includes(:comments).recent.page(params[:page]).per(15)
  end

  def index
    @user = User.all
  end
end
