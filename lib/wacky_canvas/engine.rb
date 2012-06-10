module WackyCanvas
  class Engine < ::Rails::Engine
    isolate_namespace WackyCanvas
    cattr_accessor :configurations, :instance_writer => false

    initializer "wacky_canvas.read_configurations" do |app|
      @@configurations = YAML::load(IO.read("#{Rails.root}/config/wacky_canvas.yml"))
    end
  end
end
