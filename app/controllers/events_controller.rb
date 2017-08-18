class EventsController < ApplicationController

  before_action :authenticate_user!

  def index
    if !user_signed_in?
      redirect_to new_user_session_path
    else
      @title = "- Events"
      @events = current_user.events
    end
  end

  def show
    @event = Event.find(params[:id])
    check_for_user_event_host       # to root_path if user is not tied to event
    @guests = @event.guests
    @relationships = @event.relationships
    #------ for guest form {
    @guest = Guest.new
    @relationship = Relationship.new
    @plusone = Plusone.new
    @title = @event.name
  end

  def new
    @status = "create" # to determine 'new' or 'edit' HTML in event view
    @event = Event.new
    @side_a = Couple.new
    @side_b = Couple.new
    @title = "New Event"
  end

  def create
    user_signed_in?
    @errors = nil
    @event = Event.new(event_params)
    @side_a, @side_b = Couple.new(side_a_params), Couple.new(side_b_params)
    @event_manager = EventManager.new(@event, @side_a, @side_b, current_user)
    if @event_manager.save_event
        flash[:notice] = "Event created!"
        redirect_to @event
    else
      @errors = @event.errors.full_messages + @side_a.errors.full_messages + @side_b.errors.full_messages
      @status = "create"
      render action: 'new'
    end
  end

  def edit
    user_signed_in?
    @status = "edit"
    @event = Event.find(params[:id])
    check_for_user_event_host
    @side_a = Couple.find(@event.side_a)
    @side_b = Couple.find(@event.side_b)
    @title = "Edit #{@event.name}"
  end

  def update
    user_signed_in?
    @event = Event.find(params[:id])
    check_for_user_event_host
    @side_a, @side_b = Couple.find(@event.side_a), Couple.find(@event.side_b)
    @event.update(event_params)
    @side_a.update(side_a_params)
    @side_b.update(side_b_params)
    redirect_to @event
  end

  def destroy
    user_signed_in?
    @event = Event.find(params[:id])
    check_for_user_event_host
    @event.non_universal_relationships.each { |rel| rel.destroy }
        # dependent: :destroy in event model would delete universal relationships too
    @event.destroy
    redirect_to events_path
  end

  private

  def side_a_params
    params.require(:side_a).permit(:first_name, :last_name, :notes)
  end

  def side_b_params
    params.require(:side_b).permit(:first_name, :last_name, :notes)
  end

  def event_params
    params.require(:event).permit(:name, :table_size_limit)
  end

  def save_couple(side_a, side_b)
    if side_a.valid? && side_b.valid?
      side_a.save
      side_b.save
      true
    else
      @errors = [side_a.errors.full_messages.join(" "), side_b.errors.full_messages.join(" ")]
      false
    end
  end

end
