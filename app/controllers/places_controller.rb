class PlacesController < ApplicationController
  def index
  end

  def show
    @messages = Message.where(place_id: params[:id])
    @name = params[:name]
    @place = params[:id]
  end
end
