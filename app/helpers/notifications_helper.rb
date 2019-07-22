module NotificationsHelper

  def notificatioin_detail(notification)
    sender = link_to notification.sender.name, notification.sender
    post = link_to 'あなたの投稿', show_post_path(notification.post) if notification.post_id
    case notification.action
      when "follow" then
        "#{sender}があなたをフォローしました。"
      when "bookmark" then
        "#{sender}が#{post}をお気に入りに入れました。"
      when "comment" then
        "#{sender}が#{post}にコメントしました。"
    end
  end

  def unchecked_notifications
    current_user.passive_notifications.exists?(:checked => false)
  end
end
