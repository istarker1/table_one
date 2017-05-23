class EventsController < ApplicationController

  def index
    @events = current_user.events
  end

  def show

  end

  def edit
  end

  def destroy
  end

end
