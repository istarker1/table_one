class GuestsController < ApplicationController

  before_action only: [:create, :edit, :update, :destroy] do
    :authenticate_user!
  end

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
    @rel_manager = RelationshipManager.new(@guest, @event, params[:guest][:relationship])
    @rel_manager.check_for_custom_relationship
    @plusone = Plusone.new(plusone_params)
    @g_p_mgr = GuestAndPlusoneManager.new(@guest, @plusone, @event)
    data = @g_p_mgr.save
    if !data.nil?
      flash[:notice] = "Guest added!"
      render json: data, status: :created #, location: guests_path(@guest) #???
    else
      @errors = @guest.errors.full_messages + @plusone.errors.full_messages
      @relationships = @event.relationships
      @plusone = Plusone.new if !@plusone.valid?
      render action: 'new'
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
    @rel_manager = RelationshipManager.new(@guest, @event, params[:guest][:relationship])
    @rel_manager.check_for_custom_relationship
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
    @plusones.each { |p1| p1.destroy }
    @guest.destroy
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


  # @rel_manager = RelationshipManager.new( @instance_vars, etc)
  # render json: @rel_manager.response, etc




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
