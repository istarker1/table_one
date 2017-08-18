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
    data = @g_p_mgr.new_guest_save
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
    @g_p_mgr = GuestAndPlusoneManager.new(@guest, @plusone, @event)
    to_do = @g_p_mgr.edit_guest(guest_params, plusone_params)
    if !to_do.nil?
      redirect_to @event
    else
      @errors = @event.errors.full_messages
      @relationships = @event.relationships
      @plusone = Plusone.new if @plusone.nil?
      render action: 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @guest = Guest.find(params[:event_id]) # params are reversed here
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

end
