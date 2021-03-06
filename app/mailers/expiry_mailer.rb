
class ExpiryMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  default from: "notifications@workshop.codes"

  def will_expire
    @post = Post.find(params[:id])
    @user = @post.user
    mail(to: params[:to], subject: "Your Overwatch Workshop Code will expire soon!")
  end
end
