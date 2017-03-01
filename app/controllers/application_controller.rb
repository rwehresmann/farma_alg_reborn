class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js   { render 'shared/unauthorized' }
    end
  end
end
