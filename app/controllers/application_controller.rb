class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :store_action
  
  def store_action
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
        request.path != "/users/sign_out" &&
        !request.xhr?)
      store_location_for(:user, request.fullpath)
    end
  end

  def after_sign_in_path_for(resource)
    if (session[:previous_url] == feed_path(resource))
      super
    else
      session[:previous_url] || feed_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def send_notification_by(current_user,action)
    case action
    when "comment"
      return if current_user.id == @post.id
      # threads = []
      # threads << Thread.new { comment_notification(action) }
      # threads << Thread.fork { comment_notification_mailer(@post) }
      # threads.each { |thr| thr.join }
      @notification = current_user.active_notifications.new(
        post_id: @post.id,
        comment_id: @comment.id,
        reciever_id: @post.user_id,
        action: action
      )
      t = Thread.new do
        NotificationMailer.comment_notification_mail(current_user,@post.user,@post).deliver_now if @post.user.email.present? && @post.user.notification
      end
    when "bookmark"
      return if current_user.id == @post.id
      @notification = current_user.active_notifications.new(
        post_id: @post.id,
        reciever_id: @post.user_id,
        action: action
      )
      t = Thread.new do
        NotificationMailer.bookmark_notification_mail(current_user,@post.user,@post).deliver_now if @post.user.email.present? && @post.user.notification
       end
    when "follow"
      return if current_user.id == @user.id
      @notification = current_user.active_notifications.new(
        reciever_id: @user.id,
        action: action
      )
      t = Thread.new do
        NotificationMailer.follow_notification_mail(current_user,@user).deliver_now  if @user.email.present? && @user.notification 
      end
    end
    @notification.save if @notification.valid?
  end


  protected

  def configure_permitted_parameters
    added_attrs = [ :email, :name, :username, :password, :password_confirmation, :introduction, :website, :tel, :sex, :img, :img_cahce]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
  end


  def comment_notification(action)
     @notification = current_user.active_notifications.new(
        post_id: @post.id,
        comment_id: @comment.id,
        reciever_id: @post.user_id,
        action: action
      )
  end

  def comment_notification_mailer(post)
    NotificationMailer.comment_notification_mail(current_user,post.user,post).deliver_now if post.user.email.present? && post.user.notification
  end

   def correct_user_page
      user = User.find(params[:id])
      unless current_user.id == user.id
        redirect_to new_user_session_path
      end
    end
  

end
