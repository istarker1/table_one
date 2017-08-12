class RelationshipManager

  def initialize(guest, event, custom_rel=nil)
    @guest = guest
    @event = event
    @custom_rel = custom_rel
  end

  def check_for_custom_relationship
    if @guest.guest_relationship.name == "Choose one or create your own"
      @guest.relationship_id = create_custom_relationship
    end
  end

  def create_custom_relationship
    rel = Relationship.new(name: @custom_rel, event_id: @event.id)
    rel.id if rel.save
  end

end
