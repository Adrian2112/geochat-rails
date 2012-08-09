class PlacesController < ApplicationController
  skip_before_filter :authenticate!, only: [:index]
  def index
  end

  def show
    @messages = Message.where(place_id: params[:id]).sort({created_at: -1}).limit(50).all
    @messages.reverse!
    respond_to do |format|
      format.json { render json: { messages: @messages } }
      format.html {
        @name = params[:name]
        @place = params[:id]
      }
    end
  end
end
