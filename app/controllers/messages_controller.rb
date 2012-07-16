class MessagesController < ApplicationController

  def create
    @message = Message.new(params[:message])
    @message.place_id = params[:place_id]
    @message.user = current_user

    @message.save

    respond_to do |format|
      format.js
    end
  end

end
