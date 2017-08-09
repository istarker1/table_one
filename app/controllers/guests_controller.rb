class GuestsController < ApplicationController

  def new
    @create = true
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

  def edit
    @create = false
    @event = Event.find(params[:id])        # params are reversed here...
    @guest = Guest.find(params[:event_id])  # and here.
    @plusone = @guest.plusones[0]
    if @guest.plusones == []             # creating blank plusone data if there is none
      @plusone = Plusone.new
    end
    @relationships = @event.relationships
    @title = "Edit #{@guest.first_name} #{@guest.last_name}"
  end



  # if plusone does not already exist, create via plusone_params

  def update
    @event, @guest = Event.find(params[:event_id]), Guest.find(params[:id])
    @plusone = @guest.plusones[0]
    check_for_custom_relationship
    if @guest.update(guest_params)
      if !@plusone.nil?
        remove_or_update_plusone
      elsif @plusone.nil? && plusone_params[:first_name] == "" && plusone_params[:last_name]== ""
        redirect_to @event
      else
        @plusone = Plusone.new(plusone_params)
        @plusone.guest_id = @guest.id
        if @plusone.save
          redirect_to @event
        else
          valid_guest_invalid_plusone
        end
      end
    else
      invalid_guest
    end
    redirect_to @event
  end

  def destroy
    @event = Event.find(params[:id])
    @guest = Guest.find(params[:event_id]) # params is reversed here
    @plusones = @guest.plusones
    @plusones.map { |p1| p1.delete }
    @guest.delete
    redirect_to @event
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
        params[:guest][:relationship], params[:event_id])
    end
  end

  def create_custom_relationship(rel_name, event)
    rel = Relationship.new(name: rel_name, event_id: event.to_i)
    rel.id if rel.save
  end

  def valid_guest_no_plusone
    @guest.save
    flash[:notice] = "Guest added!"
    data = {full_name: @guest.full_name, guest_id: @guest.id, event_id: @event.id,
      side: @guest.guest_side.first_name, relationship: @guest.relationship.name,
      count: @event.guest_count, relationship_id: @guest.relationship.id,
      type: "new"}
    @event.relationships.any? == [@guest.relationship.name, @guest.relationship.id] ?
      data[:relationship] = nil : data[:relationship] = @guest.relationship.name
    render json: data, status: :created #, location: guests_path(@guest) #???
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
    render json: data, status: :created #, location: guests_path(@guest) #???
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

  def update_plusone
    @plusone.update(plusone_params)
    @plusone.update(guest_id: @guest.id)
    redirect_to @event
  end

  def remove_or_update_plusone
    if plusone_params[:first_name] == "" && plusone_params[:last_name] == ""
      @plusone.destroy
    elsif plusone_params[:first_name] == "" || plusone_params[:last_name] == ""
      valid_guest_invalid_plusone
    else
      @plusone.update(plusone_params)
    end
  end

end
