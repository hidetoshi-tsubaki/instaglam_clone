class CommentsController < ApplicationController
  before_action :authenticate_user!
  # before_action :correct_user, only: [:edit,:update,:delete]

  def create
    @comment = current_user.comments.new(comment_paramater)
    @post = Post.includes(comments: :user).find(comment_paramater[:post_id])
    @comments = @post.comments.includes(:user).recent
    if @comment.save
      send_notification_by(current_user,"comment") unless current_user.id == @post.user_id
      respond_to do |format|
        format.html {redirect_to show_post_path(@post)}
        format.js {render'comments/comments'}
      end
    else
      flash.now[:alert] = 'failed to post..... try again'
      render_after_failed
    end
  end


  def delete
      comment =Comment.find(params[:id])
      if comment.destroy
        flash.now[:notice] = 'コメントは削除されました。'
        redirect_to show_post_path(comment.post_id)
      else
        flash.now[:alert] = 'コメントは削除に失敗しました。もう一度お試しください'
        redirect_to show_post_path(comment.post_id, anchor: 'comment_#{comment.post_id}')
    end
  
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
