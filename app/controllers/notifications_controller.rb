class NotificationsController < ApplicationController
  before_action do
    redirect_to login_path unless current_user
  end

  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page])
  end
end
