class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit,:update,:delete]
  def new
    @post = Post.new 
  end

  def create
    @post = current_user.posts.new(post_paramater)
    if @post.save
      flash.now[:notice] = 'post successfully!'
      redirect_to show_post_path(@post)
    else
      flash.now[:alert] = 'failed to post.... try again'
      render 'new'
    end
  end

  def show
    @post = Post.includes(:user).find(params[:id])
    @comments = @post.comments.includes(:user).recent
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit

  end

  def update

  end

  def delete

  end

  def search
    @user = User.find_by(params[:page_user_id])
    @current_user = current_user
    @posts = Post.search(params[:keyword],params[:current_page],@user.id,@current_user)
    respond_to do |format|
      format.html {redirect_to feed_path(current_user)}
      format.js
    end
  end

  private 
    def post_paramater
      params.require(:post).permit(:img, :title)
    end

    

end
