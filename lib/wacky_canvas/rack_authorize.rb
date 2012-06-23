module WackyCanvas
  class RackAuthorize
    def initialize(app)
      @app = app
    end

    def call(env)
      session = WackyCanvas::Session.new(env)
      env[:wacky_canvas] = session
      response = @app.call(env)
      session.add_remember_cookie(response[1])
      response
    end
  end 
end
