WackyCanvas::Engine.routes.draw do
  match 'session/new', :to => 'sessions#new', :via => [:get, :post], :as => 'new_session'
end
