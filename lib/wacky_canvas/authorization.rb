module WackyCanvas
  module Authorization
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signed_in?, :signed_out?
      hide_action :current_user, :signed_in?, :signed_out?, :authorize, :deny_access
    end

    # Finds the user from the Rack Wacky Canvas session
    def current_user
      wacky_canvas_session.current_user
    end
    
    def signed_in?
      wacky_canvas_session.signed_in?
    end
    
    def signed_out?
      !signed_in?
    end

    def authorize
      deny_access if signed_out?
    end

    def deny_access(flash_message = nil)
      flash[:notice] = flash_message if flash_message
      if signed_in?
        redirect_to(url_after_denied_access_when_signed_in)
      else
        redirect_to(url_after_denied_access_when_signed_out)
      end
    end

    private

    def wacky_canvas_session
      request.env[:wacky_canvas]
    end

    def url_after_denied_access_when_signed_in
      '/'
    end

    def url_after_denied_access_when_signed_out
      wacky_canvas.new_session_path 
    end
  end
end

class ActionController::Base
  include WackyCanvas::Authorization
end
