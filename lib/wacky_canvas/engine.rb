module WackyCanvas
  class Engine < ::Rails::Engine
    isolate_namespace WackyCanvas

    config.app_middleware.insert_after ActionDispatch::Cookies, WackyCanvas::RackAuthorize
  end
end
