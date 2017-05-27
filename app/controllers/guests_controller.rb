class GuestsController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
    @guests = @event.guests
    @guest = Guest.new
    @relationships = @event.relationships
  end

  def create
    @event = Event.find(params[:event_id])
    @guest = Guest.new(guest_params)
    @guest.event_id = params[:event_id]
    if @guest.save
      flash[:notice] = "Guest added!"
      redirect_to @event
    else
      @errors = @guest.errors.full_messages
      @relationships = @event.relationships
      render action: 'new'
    end
  end


  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :relationship_id,
      :side, :notes)
  end

end
