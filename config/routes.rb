WackyCanvas::Engine.routes.draw do
  match "/authorize" => "canvas#authorize", :via => [:get, :post]
end
