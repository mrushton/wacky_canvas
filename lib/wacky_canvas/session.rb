module WackyCanvas
  class Session
    REMEMBER_TOKEN_COOKIE = "remember_token".freeze

    def initialize(env)
      @env = env
    end

    def current_user
      @current_user ||= get_current_user 
    end

    def current_signed_request
      @current_signed_request ||= parse_signed_request(request.params['signed_request']) 
    end

    def signed_in?
      current_user.present?
    end

    def signed_request?
      current_signed_request.present?
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def add_remember_cookie(headers)
      # Make sure the user has been saved
      if signed_in? && !current_user.new_record?
        # The cookie expiration is only a day since we always get a signed request
        Rack::Utils.set_cookie_header!(headers, REMEMBER_TOKEN_COOKIE, :value => current_user.remember_token, :expires => 1.day.from_now, :path => "/")
      end
    end

    private

    def parse_signed_request(signed_request)
puts "parse signed request 1"
      return if signed_request.nil?
puts "parse signed request 1"
      encoded_sig, encoded_payload = signed_request.split('.')
      # Decode the data
      begin
        sig = Base64.urlsafe_decode64(add_padding(encoded_sig))
        payload = Base64.urlsafe_decode64(add_padding(encoded_payload))
      rescue ArgumentError
        return
      end
      data = ActiveSupport::JSON.decode(payload)
      # Verify signature
      if data["algorithm"] != 'HMAC-SHA256'
        return
      end
      digest = OpenSSL::Digest::Digest.new('sha256')
      expected_sig = OpenSSL::HMAC.digest(digest, WackyCanvas.configuration.app_secret, encoded_payload)
      return if expected_sig != sig
      data
    end

    def get_current_user
      # Use the signed request if present otherwise find the user
      if signed_request? 
        # Do nothing if not authorized
        return if current_signed_request["user_id"].nil?
        # Find and update the user or create a new one  
        if !(user = WackyCanvas.configuration.user_model.find_by_user_id(current_signed_request["user_id"]))
          user = WackyCanvas.configuration.user_model.new
        end
        user.user_id = current_signed_request["user_id"];
        user.oauth_token = current_signed_request["oauth_token"];
        user.expires = current_signed_request["expires"];
        user
      elsif token = cookies[REMEMBER_TOKEN_COOKIE] 
        WackyCanvas.configuration.user_model.find_by_remember_token(token)
      end
    end

    def cookies
      @cookies ||= @env['action_dispatch.cookies'] || request.cookies
    end

    def add_padding(str)
      # Add = padding 
      str += '=' while !(str.size % 4).zero?
      str
    end
  end
end
