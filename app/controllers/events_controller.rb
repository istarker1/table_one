class EventsController < ApplicationController

  def index
    if current_user.nil?
      redirect_to new_user_session_path
    else
      @events = current_user.events
    end
  end

  def show

  end

  def edit
  end

  def destroy
  end

end
