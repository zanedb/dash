class EmailsController < ApplicationController
  before_action :please_sign_in
  before_action :set_event
  before_action :set_email, only: %i[show]
  before_action :custom_authorization, only: %i[index settings configure]

  def index
  end

  def show
    authorize @email
  end

  def new
    @email = @event.emails.new
    authorize @email
  end

  def create
    @email = @event.emails.new(email_params)
    authorize @email

    if @email.save
      redirect_to event_emails_path(@event)
      flash[:success] = 'Email will be sent shortly.'
    else
      render :new
    end
  end

  def settings
    @email_config = @event.email_config
  end

  def configure
    if @event.email_config.update(email_config_params)
      redirect_to event_emails_path(@event)
      flash[:success] = 'Email sending has been configured.'
    else
      render :edit
    end
  end

  private

  def set_email
    @email = @event.emails.find(params[:id])
  end

  def email_params
    params.require(:email).permit(:recipient, :sender_email, :subject, :body)
  end

  def email_config_params
    params.require(:email_config).permit(:smtp_url, :smtp_port, :authentication, :domain, :sender_email, :username, :password)
  end
end
