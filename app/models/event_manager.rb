class EventManager

  def initialize(event, side_a, side_b, current_user)
    @event = event
    @side_a = side_a
    @side_b = side_b
    @current_user = current_user
  end

  def save_event
    if @event.save
      @side_a.event = @event
      @side_b.event = @event
      if save_couple(@side_a, @side_b)
        @host = Host.create(event_id: @event.id, user_id: @current_user.id)
        @event.update(side_a: @side_a.id, side_b: @side_b.id)
        true
      else
        false
      end
    else
      false
    end
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
