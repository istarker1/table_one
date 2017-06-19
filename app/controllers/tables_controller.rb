class TablesController < ApplicationController

  def index
    @guest_count, @table_num = 0, 1
    @event = Event.find(params[:event_id])
    @event.create_arrangement
    @event = Event.find(params[:event_id])
  end

end
