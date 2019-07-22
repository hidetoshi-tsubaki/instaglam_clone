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
      @notification = current_user.active_notifications.new(
        post_id: @post.id,
        comment_id: @comment.id,
        reciever_id: @post.user_id,
        action: action
      )
      NotificationMailer.comment_notification_mail(current_user,@post.user,@post).deliver_now unless @post.user.email && @post.user.notification
    when "bookmark"
      return if current_user.id == @post.id
      @notification = current_user.active_notifications.new(
        post_id: @post.id,
        reciever_id: @post.user_id,
        action: action
      )
      NotificationMailer.bookmark_notification_mail(current_user,@post.user,@post).deliver_now unless @post.user.email && @post.user.notification
    when "follow"
      return if current_user.id == @user.id
      @notification = current_user.active_notifications.new(
        reciever_id: @user.id,
        action: action
      )
      NotificationMailer.follow_notification_mail(current_user,@user).deliver_now  unless @user.email && @user.notification 
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

  def correct_user
    user = User.find(params[:id])
    redirect_to feed_path(current_user)  unless user == current_user
  end
  

end
