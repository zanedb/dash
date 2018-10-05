class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(_resource)
  end

  def after_update_path_for(_resource)
  end

  def update_resource(resource, params)
    return super if params[:password]&.present?
    resource.update_without_password(params.except(:current_password))
  end

end