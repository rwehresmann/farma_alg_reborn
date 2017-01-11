class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    # 'now' is required because else the flash doesn't desapear when page is
    # reloaded.
    flash.now[:alert] = exception.message
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js   { render 'shared/unauthorized' }
    end
  end
end
