# frozen_string_literal: true

class HardwareItemsController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_hardware
  before_action :set_hardware_item
  before_action -> { authorize @hardware_item }

  def show
    @barcode = @hardware_item.barcode
    @barcode_svg = @hardware_item.barcode_svg

    respond_to do |format|
      format.html
      format.pdf do
        send_data @hardware_item.pdf
      end
    end
  end

  def edit; end

  def update
    if @hardware_item.update(hardware_item_params)
      flash[:success] = 'Hardware updated.'
      redirect_to event_hardware_hardware_item_path(@event, @hardware, @hardware_item)
    else
      render :edit
    end
  end

  def check_out
    @hardware_item&.checked_out_to_file&.purge
    if @hardware_item.update(
      checked_out_by_id: current_user_id,
      checked_out_to: params[:hardware_item][:checked_out_to],
      checked_out_at: Time.now,
      checked_in_by_id: nil,
      checked_in_at: nil
    )
      if params[:hardware_item][:checked_out_to_file]
        @hardware_item.update(checked_out_to_file: params[:hardware_item][:checked_out_to_file])
      end
      flash[:success] = "#{@hardware_item.description} checked out."
    else
      flash[:error] = "Failed to check out #{@hardware_item.description}."
    end
    redirect_to request.referrer || event_hardware_path(@event, @hardware)
  end

  def check_in
    return false if @hardware_item.checked_in?

    if @hardware_item.checked_out?
      if @hardware_item.update(
        checked_in_by_id: current_user_id,
        checked_in_at: Time.now
      )
        flash[:success] = "#{@hardware_item.description} checked in."
      else
        flash[:error] = "Failed to check in #{@hardware_item.description}."
      end
    else
      flash[:error] = 'Must be checked out first.'
    end
    redirect_to request.referrer || event_hardware_path(@event, @hardware)
  end

  def destroy
    @hardware_item.destroy
    @hardware.update(quantity: @hardware.hardware_items.count)
    flash[:success] = 'Hardware item removed.'
    redirect_to event_hardware_path(@event, @hardware)
  end

  private

  def set_hardware
    @hardware = @event.hardwares.friendly.find_by_friendly_id(params[:hardware_id])
  end

  def set_hardware_item
    @hardware_item = @hardware.hardware_items.find(params[:barcode] || params[:hardware_item_barcode])
  end

  def hardware_item_params
    params.require(:hardware_item).permit(:barcode)
  end
end
