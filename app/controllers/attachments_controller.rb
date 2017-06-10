class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = @question = Attachment.find(params[:id])
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash[:notice] = 'Attachment was successfully deleted'
    else
      head :forbidden
    end
  end
end