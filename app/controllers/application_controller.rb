# frozen_string_literal: true

class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'user',
                               password: 'mcKekj7jBzz7spaV36aQNZS3',
                               unless: -> { Rails.env.development? }
  include Pundit
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, Pundit::NotAuthorizedError,
              with: :record_not_found unless Rails.env.development?
  helper_method :nobody_signed_in?, :current_user_id, :is_my?, :isnt_my?

  # Keep the current user id in memory
  def current_user_id
    return unless current_user
    session[:user_id] ||= current_user.id
    session[:user_id]
  end

  # Is anyone signed in?
  def someone_signed_in?
    current_user_id.present?
  end

  # The opposite of there being someone signed in
  def nobody_signed_in?
    !someone_signed_in?
  end

  # Redirect visitor if they're not signed in
  def please_sign_in
    if nobody_signed_in?
      flash[:error] = 'Please sign in first.'
      redirect_to new_user_session_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[name]
    devise_parameter_sanitizer.permit :account_update, keys: %i[name password current_password]
    devise_parameter_sanitizer.permit :accept_invitation, keys: %i[name]
  end

  def record_not_found
    render 'pages/not_found', status: 404
  end
end
