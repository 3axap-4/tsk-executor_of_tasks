class TaskAttachmentsController < ApplicationController
  
  before_action :check_sign_in, only: [:destroy]
  before_filter :set_attachment, only: [:destroy]


  def destroy
    @attachment.destroy!
    render json: { success: true }   
  end

  def download_attachment
  end

  private 

  	def set_attachment
  		@attachment = Attachment.find(params[:id]) 
  	end


end
