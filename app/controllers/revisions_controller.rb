class RevisionsController < ApplicationController
  before_action :set_revision

  before_action do
    redirect_to root_path unless current_user && current_user == @revision.post.user && @revision.visible
  end

  def edit
  end

  def update
    if @revision.update(revision_params)
      create_activity(:update_revision, revision_activity_params)

      redirect_to post_path(@revision.post.code)
    else
      render :edit
    end
  end

  private

  def set_revision
    @revision = Revision.find(params[:id])
  end

  def revision_activity_params
    { ip_address: last_4_digits_of_request_ip, id: @revision.id }
  end

  def revision_params
    params.require(:revision).permit(:version, :description)
  end
end
