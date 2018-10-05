class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[name]
    devise_parameter_sanitizer.permit :account_update, keys: %i[name password current_password]
  end
end
