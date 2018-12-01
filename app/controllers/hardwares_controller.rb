# frozen_string_literal: true

class HardwaresController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_hardware, except: %i[index new create]
  before_action -> { authorize @hardware }, except: %i[index new create]

  def index
    # manually authenticate index methods, Pundit doesn't
    if @event.users.include?(current_user) || current_user.admin?
      @hardwares = @event.hardwares
    else
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def new
    @hardware = @event.hardwares.new
    authorize @hardware
  end

  def show
    @hardware_items = @hardware.hardware_items
  end
  
  def edit; end

  def create
    @hardware = @event.hardwares.new(hardware_params)
    authorize @hardware

    if @hardware.save
      flash[:success] = 'Hardware was successfully created.'
      redirect_to event_hardware_path(@event, @hardware)
    else
      render :new
    end
  end

  def update
    if @hardware.update(hardware_params)
      flash[:success] = 'Hardware was successfully updated.'
      redirect_to event_hardware_path(@event, @hardware)
    else
      render :edit
    end
  end

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
