class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
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
      @alert = 'Please sign in first.'
      redirect_to root_url
    end
  end

  # Is this thing mine?
  def is_my?(object)
    someone_signed_in? && object.user_id == current_user_id
  end

  # Is this thing _not_ mine?
  def isnt_my?(object)
    !is_my? object
  end

  # Redirect user if the current object isn't theirs
  def hey_thats_my(object)
    please_sign_in
    if isnt_my? object
      alert = "That's not yours."
      redirect_to root_url
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[name]
    devise_parameter_sanitizer.permit :account_update, keys: %i[name password current_password]
  end
end
