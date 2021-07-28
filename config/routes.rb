Rails.application.routes.draw do
  get 'uploader/Thumbnail'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        collection do
          post 'signup'
        end
      end

      resources :projects, only: [] do
        collection do
          #Project Routing
          post '/', to: 'projects#create'
          get '/my_projects', to: 'projects#my_projects'
          get '/:id', to: 'projects#show'
          get '/', to: 'projects#index'
          put '/:id', to: 'projects#update'
          delete '/:id', to: 'projects#destroy'

          #Contents routing
          post '/:id/contents', to: 'contents#create'
          get '/:id/contents', to: 'contents#index'
          get '/:id/contents/:contentId', to: 'contents#show'
        end
      end

      resources :contents, only: [] do
        collection do
          put '/:id', to: 'contents#update'
          delete '/:id', to: 'contents#destroy'
        end
      end

      resources :auth, only: [] do
        collection do
          post '/signin' => 'user_token#create'
        end
      end

    end
  end
end
