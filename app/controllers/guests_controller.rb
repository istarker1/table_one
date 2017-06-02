class GuestsController < ApplicationController

  # def new
  #   @event = Event.find(params[:event_id])
  #   @guests = @event.guests
  #   @guest = Guest.new
  #   @relationships = @event.relationships
  #   @relationship = Relationship.new
  #   @plusone = Plusone.new
  # end

  def create
    @event = Event.find(params[:event_id])
    @guest = Guest.new(guest_params)
    @guest.event_id = params[:event_id]
    check_for_custom_relationship
    @plusone = Plusone.new(plusone_params)
    if @guest.valid?
      if @plusone.first_name == "" && @plusone.last_name == "" # no plusone data entered
        valid_guest_no_plusone
      elsif @plusone.valid?
        valid_guest_valid_plusone
      else
        valid_guest_invalid_plusone
      end
    else
      invalid_guest
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

  def check_for_custom_relationship
    if @guest.guest_relationship.name == "Choose one or create your own"
      @guest.relationship_id = create_custom_relationship(
        params[:guest][:relationship] ,params[:event_id])
    end
  end

  def create_custom_relationship(rel_name, event)
    rel = Relationship.new(name: rel_name, event_id: event.to_i)
    rel.id if rel.save
  end

  def valid_guest_no_plusone
    @guest.save
    flash[:notice] = "Guest added!"
    redirect_to @event
  end

  def valid_guest_valid_plusone
    @guest.save
    @plusone.guest = @guest
    @plusone.save
    redirect_to @event
  end

  def valid_guest_invalid_plusone
    @errors = @plusone.errors.full_messages
    @relationships = @event.relationships
    render action: 'new'
  end

  def invalid_guest
    @errors = @guest.errors.full_messages
    @relationships = @event.relationships
    @plusone = Plusone.new
    render action: 'new'
  end

end
