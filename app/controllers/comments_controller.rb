class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit,:update,:delete]

  def create
    @comment = current_user.comments.new(comment_paramater)
    @post = Post.includes(comments: :user).find(comment_paramater[:post_id])
    @comments = @post.comments.recent
    p "######"
    p @comments
    if @comment.save
      send_notification_by(current_user,"comment") unless current_user.id == comment_paramater[:post_id]
      respond_to do |format|
        format.html {redirect_to show_post_path(@post)}
        format.js {render'comments/comments'}
      end
    else
      flash.now[:alert] = 'failed to post..... try again'
      render_after_failed
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  private
    def comment_paramater
      params.require(:comment).permit(:content,:post_id)
    end

    def render_after_failed
      if (controller_path == 'posts' && action_name == 'show')
        render 'posts/show' and return
      elsif (controller_path == 'pages' && action_name == 'feed')
        render 'pages/feed' and return
      else
        redirect_to feed_path(current_user)
      end
    end
end
