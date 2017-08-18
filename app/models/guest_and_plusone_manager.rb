class GuestAndPlusoneManager

  def initialize(guest, plusone, event)
    @guest = guest
    @plusone = plusone
    @event = event
  end

  def new_guest_save
    if @guest.valid?
      if @plusone.first_name == "" && @plusone.last_name == "" # no plusone data entered
        valid_guest_no_plusone
      elsif @plusone.valid?
        valid_guest_valid_plusone
      else
        invalid_guest_andor_plusone
      end
    else
      invalid_guest_andor_plusone
    end
  end

  def edit_guest(guest_params, plusone_params)
    if @guest.update(guest_params)
      if !@plusone.nil?
        remove_or_update_plusone(@guest, plusone_params)
      elsif @plusone.nil? && plusone_params[:first_name] == "" && plusone_params[:last_name]== ""
        "redirect"
      else
        @plusone = Plusone.new(plusone_params)
        @plusone.guest_id = @guest.id
        if @plusone.save
          "redirect"
        else
          invalid_guest_andor_plusone
        end
      end
    else
      invalid_guest_andor_plusone
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

  def invalid_guest_andor_plusone
    nil
  end

  def update_plusone
    @plusone.update(plusone_params)
    @plusone.update(guest_id: @guest.id)
    "redirect"
  end

  def remove_or_update_plusone(guest, plusone_params)
    if plusone_params[:first_name] == "" && plusone_params[:last_name] == ""
      @plusone.destroy
      "redirect"
    elsif plusone_params[:first_name] == "" || plusone_params[:last_name] == ""
      invalid_guest_andor_plusone
    else
      @plusone.update(plusone_params)
      @plusone.update(guest_id: guest.id)
      "redirect"
    end
  end

      # update just guest               - redirect_to
      # update guest & update plusone   - redirect_to
      # update guest & create plusone   - redirect_to
      # update guest & delete plusone   - redirect_to
      # invalid guest                   - render 'edit'
      # invalid plusone                 - render 'edit'

end
