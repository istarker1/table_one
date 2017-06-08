class TablesController < ApplicationController

  def index
    @event = Event.find(params[:event_id])
    @event.create_tables
    @event.create_arrangement

  end

end
