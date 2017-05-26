class GuestsController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
    @guests = @event.guests
    @guest = Guest.new
    @relationships = @event.relationships
  end

  def create
    @guest = Guest.new(guest_params)
    binding.pry
    if @guest.save

    else

    end
  end


  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :relationship,
      :side, :notes)
  end

end
