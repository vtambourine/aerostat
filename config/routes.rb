Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'pages#index'

  resources :episodes, only: [:index, :show]
  resources :tracks, only: [:index, :show] do
    member do
      get 'some'
    end
  end

  resources :artists, only: [:index, :show]

end
