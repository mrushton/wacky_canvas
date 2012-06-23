require_dependency "wacky_canvas/application_controller"

module WackyCanvas
  class SessionsController < ApplicationController
    def new 
      @app_id = WackyCanvas.configuration.app_id
      @app_namespace = WackyCanvas.configuration.app_namespace
      @app_scope = WackyCanvas.configuration.app_scope
      @redirect_path = WackyCanvas.configuration.redirect_path
      render :layout => false 
    end
  end
end
