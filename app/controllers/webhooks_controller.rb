# frozen_string_literal: true

class WebhooksController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_webhook, except: %i[index new create]
  before_action -> { authorize @webhook }, except: %i[index new create]

  def index
    # manually authenticate index methods, Pundit doesn't
    if @event.users.include?(current_user) || current_user.admin?
      @webhooks = @event.webhooks
    else
      raise Pundit::NotAuthorizedError, 'not allowed to view this action'
    end
  end

  def new
    @webhook = @event.webhooks.new
    authorize @webhook
  end

  def show; end
  
  def edit; end

  def create
    @webhook = @event.webhooks.new(webhook_params)
    authorize @webhook

    if @webhook.save
      flash[:success] = 'Webhook was successfully created.'
      redirect_to event_webhooks_path(@event)
    else
      render :new
    end
  end

  def update
    if @webhook.update(webhook_params)
      flash[:success] = 'Webhook was successfully updated.'
      redirect_to event_webhook_path(@event, @webhook)
    else
      render :edit
    end
  end

  def destroy
    @webhook.destroy
    flash[:success] = 'Webhook was successfully destroyed.'
    redirect_to event_webhooks_path(@event)
  end

  private

  def set_webhook
    @webhook = @event.webhooks.find_by_id(params[:id])
  end

  def webhook_params
    params.require(:webhook).permit(:name, :url, :request_type)
  end
end
