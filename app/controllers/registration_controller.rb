class RegistrationsController < Devise::RegistrationsController

  protected

    def after_update_path_for(resource)
      root_path + "/"
    end

end

