class GuestAndPlusoneManager

  def initialize(guest, plusone, event)
    @guest = guest
    @plusone = plusone
    @event = event
  end

  def save
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

  def valid_guest_no_plusone
    @guest.save
    data = {full_name: @guest.full_name, guest_id: @guest.id, event_id: @event.id,
      side: @guest.guest_side.first_name, relationship: @guest.relationship.name,
      count: @event.guest_count, relationship_id: @guest.relationship.id,
      type: "new"}
    @event.relationships.any? == [@guest.relationship.name, @guest.relationship.id] ?
      data[:relationship] = nil : data[:relationship] = @guest.relationship.name
    data
  end

  def valid_guest_valid_plusone
    @guest.save
    @plusone.guest = @guest
    @plusone.save
    data = {full_name: @guest.full_name, guest_id: @guest.id, event_id: @event.id,
      side: @guest.guest_side.first_name, relationship: @guest.relationship.name,
      plusone: "#{@guest.plusones[0].first_name} #{@guest.plusones[0].last_name}",
      count: @event.guest_count, relationship_id: @guest.relationship.id,
      type: "new"}
    @event.relationships.any? == [@guest.relationship.name, @guest.relationship.id] ?
      data[:relationship] = nil : data[:relationship] = @guest.relationship.name
    data
  end

  def valid_guest_invalid_plusone
    @errors = @plusone.errors.full_messages
    @relationships = @event.relationships
    nil
  end

  def invalid_guest
    @errors = @guest.errors.full_messages
    @relationships = @event.relationships
    @plusone = Plusone.new
    nil
  end

end
