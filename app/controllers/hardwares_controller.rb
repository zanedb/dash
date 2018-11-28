class HardwaresController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_hardware, only: %i[edit update destroy check_out check_in]
  before_action -> { authorize @hardware }, only: %i[edit update destroy check_out check_in]

  # GET /hardwares
  def index
    # manually authenticate index methods, Pundit doesn't
    if @event.users.include?(current_user) || current_user.admin?
      @hardwares = @event.hardwares
    else
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  # GET /hardwares/new
  def new
    @hardware = Hardware.new
    authorize @hardware
  end

  # GET /hardwares/1/edit
  def edit
  end

  # POST /hardwares
  def create
    @hardware = @event.hardwares.new(hardware_params.merge(user: current_user))
    authorize @hardware
               
    if @hardware.save
      flash[:success] = 'Hardware was successfully created.'
      redirect_to @hardware
    else
      render :new
    end
  end

  # PATCH/PUT /hardwares/1
  def update
    if @hardware.update(hardware_params)
      flash[:success] = 'Hardware was successfully updated.'
      redirect_to @hardware
    else
      render :edit
    end
  end
    
  # DELETE /hardwares/1
  def destroy
    @hardware.destroy
    flash[:success] = 'Hardware was successfully destroyed.'
    redirect_to event_hardwares_path(@event)
  end

  private

  def set_hardware
    @hardware = @event.hardwares.friendly.find_by_friendly_id(params[:id])
  end

  def hardware_params
    params.require(:hardware).permit(:vendor, :model, :quantity)
  end
end
