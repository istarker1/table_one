class GuestsController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
    @guests = @event.guests
    @guest = Guest.new
    @relationships = @event.relationships
    @relationship = Relationship.new
    @plusone = Plusone.new
  end

  def create
    @event = Event.find(params[:event_id])
    @guest = Guest.new(guest_params)
    @guest.event_id = params[:event_id]
    if @guest.guest_relationship.name == "Choose one or create your own"
      @guest.relationship_id = create_custom_relationship(
        params[:guest][:relationship] ,params[:event_id])
    end
    @plusone = Plusone.new(plusone_params)
    if @guest.valid?
      if @plusone.first_name == "" && @plusone.last_name == "" # no plusone data entered
        @guest.save
        flash[:notice] = "Guest added!"
        redirect_to @event
      elsif @plusone.valid?
        @guest.save
        @plusone.guest = @guest
        @plusone.save
        redirect_to @event
      else
        @errors = @plusone.errors.full_messages
        @relationships = @event.relationships
        render action: 'new'
      end
    else
      @errors = @guest.errors.full_messages
      @relationships = @event.relationships
      @plusone = Plusone.new
      render action: 'new'
    end
  end

#----------------------------------
  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :relationship_id,
      :side, :notes)
  end

  def plusone_params
    params.require(:plusone).permit(:first_name, :last_name, :notes)
  end

  def create_custom_relationship(rel_name, event)
    rel = Relationship.new(name: rel_name, event_id: event.to_i)
    if rel.save
      rel.id
    else
      nil
    end
  end

end
