require_dependency "wacky_canvas/application_controller"

module WackyCanvas
  class CanvasController < ApplicationController
    def authorize
      if params[:signed_request].nil?
        render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
        return
      end
      encoded_sig, encoded_payload = params[:signed_request].split('.')
      # Decode the data
      begin
        sig = Base64.urlsafe_decode64(add_padding(encoded_sig))
        payload = Base64.urlsafe_decode64(add_padding(encoded_payload))
      rescue ArgumentError
        render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
        return
      end
      data = ActiveSupport::JSON.decode(payload)
      # Verify signature
      if data["algorithm"] != 'HMAC-SHA256'
        render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
        return
      end
      digest = OpenSSL::Digest::Digest.new('sha256')
      expected_sig = OpenSSL::HMAC.digest(digest, WackyCanvas::Engine.configurations[Rails.env]["app_secret"], encoded_payload)
      if expected_sig != sig
        render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
        return
      end
      cookies[:wacky_canvas_remember_token] = { :value => SecureRandom.hex(16), :expires => 20.years.from_now } if cookies[:wacky_canvas_remember_token].nil?
      wacky_canvas_session = Session.find_by_remember_token(cookies[:wacky_canvas_remember_token])
      # Create a new Session object if one does not exist
      if wacky_canvas_session.nil?
        wacky_canvas_session = Session.new
        wacky_canvas_session.remember_token = cookies[:wacky_canvas_remember_token]
        wacky_canvas_session.save!
      end
      # Create a new View object and update it
      view = View.new
      view.session_id = wacky_canvas_session.id
      if !data["user_id"].nil?
        view.user_id = data["user_id"];
        view.oauth_token = data["oauth_token"];
        view.expires = data["expires"];
        # Save session data
        session[:user_id] = view.user_id
        session[:oauth_token] = view.oauth_token
      end
      view.gender = data["user"]["gender"];
      view.locale = data["user"]["locale"];
      view.country = data["user"]["country"];
      view.min_age = data["user"]["age"]["min"];
      view.max_age = data["user"]["age"]["max"];
      view.error = params["error"]
      view.error_reason = params["error_reason"]
      view.error_description = params["error_description"]
      view.save!
      # Redirect if user cancels and it is configured otherwise prompt again
      if !view.error.nil?
        if !WackyCanvas::Engine.configurations[Rails.env]["error_url"].nil?
          redirect_to WackyCanvas::Engine.configurations[Rails.env]["error_url"]
          return
        end
      end
      if !view.user_id.nil?
        redirect_to WackyCanvas::Engine.configurations[Rails.env]["redirect_url"]
        return
      end
      @app_id = WackyCanvas::Engine.configurations[Rails.env]["app_id"]
      @app_namespace = WackyCanvas::Engine.configurations[Rails.env]["app_namespace"]
      @app_scope = WackyCanvas::Engine.configurations[Rails.env]["app_scope"]
    end

    private

    def add_padding(str)
      # Add = padding 
      str += '=' while !(str.size % 4).zero?
      str
    end
  end
end
