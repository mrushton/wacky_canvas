module WackyCanvas 
  module User
    extend ActiveSupport::Concern

    included do
      include Callbacks
    end

    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_create :generate_remember_token
      end
    end

    protected

    def generate_random_code(length = 20)
      if RUBY_VERSION >= '1.9'
        SecureRandom.hex(length).encode('UTF-8')
      else
        SecureRandom.hex(length)
      end
    end

    def generate_remember_token
      self.remember_token = generate_random_code
    end
  end
end
