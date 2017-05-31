class EventsController < ApplicationController

  def index
    if current_user.nil?
      redirect_to new_user_session_path
    else
      @events = current_user.events
    end
  end

  def show
    @event = Event.find(params[:id])
    @guests = @event.guests
    @relationships = @event.relationships
  end

  def new
    @event = Event.new
    @side_a = Couple.new
    @side_b = Couple.new
  end

  def create
    @errors = nil
    @side_a, @side_b = Couple.new(side_a_params), Couple.new(side_b_params)
    @event = Event.new(event_params)
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
  end

  def destroy
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
