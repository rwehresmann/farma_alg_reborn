class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js   { render 'shared/unauthorized', status: :unauthorized }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :teacher])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
