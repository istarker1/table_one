class TablesController < ApplicationController

  def index
    @event = Event.find(params[:event_id])
    @event.create_arrangement
    binding.pry

  end

end
