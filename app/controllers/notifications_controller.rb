class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user_page, only: [:index,:history,:mail_notificatioin_toggle]

  def index
    @notifications = Notification.includes(:sender,:post,:comment).where(reciever_id: current_user.id).recent.page(params[:page]).per(15)
    # @notifications = current_user.passive_notifications.includes(:sender,:post,:comment).where(reciever_id:current_user.id,checked: false).recent.page(params[:page]).per(15)
    # Notification.where(reciever_id:current_user.id,checked: false).update(checked: true)
  end

  def history
    @notifications = current_user.passive_notifications.includes(:sender,:post,:comment).recent.page(params[:page]).per(15)
    render 'notifications/index'
  end

  def mail_notification_toggle
    user = User.find(params[:id])
    if user.notification
      user.update(notification: false) if user.valid?
      flash.now[:notice] = 'メール通知をOFFにしました。'
    else
      user.update(notification: true) if user.valid?
      flash.now[:notice] = 'メール通知をONにしました。'
    end
  end

end
