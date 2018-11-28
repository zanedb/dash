class HardwaresController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_hardware, only: %i[show edit update destroy check_out check_in]
  before_action -> { authorize @hardware }, only: %i[show edit update destroy check_out check_in]

  # GET /hardwares
  def index
    # manually authenticate index methods, Pundit doesn't
    if @event.users.include?(current_user) || current_user.admin?
      @hardwares = @event.hardwares
    else
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  # GET /hardwares/1
  def show
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
    for i in 0..hardware_params[:quantity].to_i
      @hardware = Hardware.create(hardware_params)
    end
    authorize @hardware 
               
    if @hardware.save
      flash[:success] = 'Hardware was successfully created.'
      redirect_to @hardware
    else
      render :new
     end
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

  def check_out
    if @hardware.update(
      checked_out_by_id: current_user_id,
      checked_out_to: params[:checked_out_to],
      checked_out_at: Time.now
    )
      flash[:success] = "Checked out #{@hardware.description}."
    else
      flash[:error] = "Failed to check out #{@hardware.description}."
    end
    redirect_to event_hardwares_path(@event)
  end

  def check_in
    if @hardware.update(checked_out_by_id: null, checked_out_to: null, checked_out_at: null)
      flash[:success] = "Checked in #{@hardware.description}"
    else
      flash[:error] = "Failed to check in #{@hardware.description}."
    end
    redirect_to event_hardwares_path(@event)
  end
    
  # DELETE /hardwares/1
  def destroy
    @hardware.destroy
    flash[:success] = 'Hardware was successfully destroyed.'
    redirect_to event_hardwares_path(@event)
  end

  private

  def set_hardware
    @hardware = @event.hardwares.find(params[:barcode])
  end

  def hardware_params
    params.require(:hardware).permit(:vendor, :model, :checked_out_to, :checked_out_at, :checked_out_by, :barcode, :quantity)
  end
end
