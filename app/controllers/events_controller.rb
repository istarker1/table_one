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
    check_for_user_event_host        # to root_path if user is not tied to event
    @guests = @event.guests
    @relationships = @event.relationships
    #------ for guest form
    @guest = Guest.new
    @relationship = Relationship.new
    @plusone = Plusone.new
    @title = @event.name
  end

  def new
    @event = Event.new
    @side_a = Couple.new
    @side_b = Couple.new
    @title = "New Event"
  end

  def create
    user_logged_in?
    @errors = nil
    @event = Event.new(event_params)
    @side_a, @side_b = Couple.new(side_a_params), Couple.new(side_b_params)
    if @event.save
      @side_a.event = @event
      @side_b.event = @event
      if save_couple(@side_a, @side_b)
        @host = Host.create(event_id: @event.id, user_id: current_user.id)
        @event.update(side_a: @side_a.id, side_b: @side_b.id)
        flash[:notice] = "Event created!"
        redirect_to @event
      else
        render action: 'new'
      end
    else
      @errors = @event.errors.full_messages
      render action: 'new'
    end
  end

  def edit
    user_logged_in?
    @event = Event.find(params[:id])
    check_for_user_event_host
    @side_a = Couple.find(@event.side_a)
    @side_b = Couple.find(@event.side_b)
    @title = "Edit #{@event.name}"
  end

  def update
    user_logged_in?
    @event = Event.find(params[:id])
    check_for_user_event_host
    @side_a, @side_b = Couple.find(@event.side_a), Couple.find(@event.side_b)
    @event.update(event_params)
    @side_a.update(side_a_params)
    @side_b.update(side_b_params)
    redirect_to @event
  end

  def destroy
    user_logged_in?
    @event = Event.find(params[:id])
    check_for_user_event_host
    @guests = @event.guests #array
    @sides = @event.sides # array
    @tables = @event.tables
    @tables.each { |t| t.destroy }
    @guests.each do |guest|
      guest.plusones.each { |p1| p1.destroy }
      guest.destroy
    end
    @sides.each { |s| s.destroy }
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
