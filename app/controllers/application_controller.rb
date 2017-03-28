class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for(resource)
    if resource.is_a? Admin
      admin_path resource
    elsif resource.is_a? Consumer
      consumer_path resource
    elsif resource.is_a? Employee
      employee_path resource
    end
  end

  def current_user
    current_admin || current_consumer || current_employee
  end
end
