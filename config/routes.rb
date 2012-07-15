GeochatRails::Application.routes.draw do
  
  resource :places, only: [:index, :show]

  match "/auth/:provider/callback", to: "sessions#create"
  match 'auth/failure', to: redirect('/')
  match 'logout', to: 'sessions#destroy', as: 'logout'




  root to: "places#index"
end
