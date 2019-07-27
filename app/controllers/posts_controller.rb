class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit,:update,:delete]
  def new
    @post = Post.new 
  end

  def create
    @post = current_user.posts.new(post_params)
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
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    if post.update!(post_params)
      flash.now[:notice] = "投稿画像を編集しました。"
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "編集内容が正常に保存されませんでした。"
      render :edit
    end
  end

  def delete
    if Post.find(params[:id]).destroy
      flash.now[:notice] = "投稿は削除されました"
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "投稿の削除に失敗しました"
    end

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
    def post_params
      params.require(:post).permit(:img, :title, :img_chahe)
    end

    def correct_user
      @post = Post.find_by(params[:id])
      redirect_to feed_path(current_user) unless current_user.id == @post.user_id
    end
    

end
