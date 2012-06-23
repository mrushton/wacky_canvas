module WackyCanvas 
  class Configuration
    attr_accessor :app_id, :app_secret, :app_namespace, :app_scope, :redirect_path, :user_model

    def user_model
      @user_model || ::User
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
