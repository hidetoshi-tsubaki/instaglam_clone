class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def follow
    @user = User.find(params[:id])
    current_user.follow(@user)
    send_notification_by(current_user,"follow")
    render 'follow'
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    render 'follow'
  end
end
