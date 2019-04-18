Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :readings, only: %i[show create]

      resources :thermostats, only: [] do 
      	collection do
      		get '/generate_auth_token', to: 'thermostats#generate_auth_token'
          get '/stats', to: 'thermostats#stats'
        end
      end
    end
  end
end
