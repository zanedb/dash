# frozen_string_literal: true

class HardwaresController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_hardware
  before_action :set_hardware_item, except: [:index]
  before_action -> { authorize @hardware_item }, except: [:index]

  def index
    # manually authenticate index methods, Pundit doesn't
    if @event.users.include?(current_user) || current_user.admin?
      @hardwares = @event.hardwares
    else
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def show; end

  def edit; end

  def update
    if @hardware_item.update(hardware_item_params)
      flash[:success] = 'Hardware was successfully updated.'
      redirect_to @hardware_item
    else
      render :edit
    end
  end

  def check_out
    if @hardware_item.update(
      checked_out_by_id: current_user_id,
      checked_out_to: params[:checked_out_to],
      checked_out_at: Time.now)
      flash[:success] = "Checked out #{@hardware_item.description}."
    else
      flash[:error] = "Failed to check out #{@hardware_item.description}."
    end
    redirect_to event_hardwares_path(@event)
  end

  def check_in
    if @hardware_item.check_in!
      flash[:success] = "Checked in #{@hardware_item.description}"
    else
      flash[:error] = "Failed to check in #{@hardware_item.description}."
    end
    redirect_to event_hardwares_path(@event)
  end

  def destroy
    @hardware_item.destroy
    flash[:success] = 'Hardware item removed.'
    redirect_to event_hardwares_path(@event)
  end

  private

  def set_hardware
    @hardware = @event.hardwares.friendly.find_by_friendly_id(params[:id])
  end

  def set_hardware_item
    @hardware_item = @hardware.hardware_items.find(params[:barcode])
  end
end
