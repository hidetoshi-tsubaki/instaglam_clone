class NotificationMailer < ApplicationMailer

  def comment_notification_mail(current_user,reciever,post)
    @sender = current_user
    @reciever = reciever
    @post = post
    mail to: reciever.email, subject: "#{current_user.name}があなたの投稿にコメントしました。 "
  end

  def follow_notification_mail(current_user,reciever)
    @sender = current_user
    @reciever = reciever
    mail to: reciever.email, subject: "#{current_user.name}があなたをフォローしました。"
  end

  def bookmark_notification_mail(current_user,reciever,post)
    @sender = current_user
    @reciever = reciever
    @post = post
    mail to: reciever.email, subject: "#{current_user.name}があなたの投稿をお気に入りに追加しました。"
  end

end