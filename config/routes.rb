Rails.application.routes.draw do
  # See how all your routes lay out with "rake routes".

  root                     to: 'special_pages#homepage'
  get 'new'                 => 'special_pages#new_to_cornerstone'
  get 'times-and-locations' => 'special_pages#times_and_locations'
  get 'invest'              => 'special_pages#invest_in_cornerstone' 

  resources :media do
  end
  
  # Library
  resources :studies, only: [:index, :show ], path: 'library' do
    resources :lessons, only: [:index, :show ] do
      resources :questions, only: [:index, :show, :new, :create], shallow: true do
        post :block, :star, :on => :member
        resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true do
          post :block, :star, :on => :member
        end
      end
    end
  end
  
  # # Questions
  # resources :questions do
  #   resources :answers
  # end

  # Groups
  resources :groups do
    resources :meetings do
      resources :questions, only: [:index, :new, :create]
      # NOTE: :block, :star, :show, :answers 
      # already part of the previous shallow routes
    end
  end
  
  devise_for :users, :skip => [:sessions]
  as :user do
    get     'join' => 'devise/registrations#new', :as => :new_registrations
    get     'login' => 'devise/sessions#new',      :as => :new_user_session
    post    'login' => 'devise/sessions#create',   :as => :user_session
    delete  'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get     'logout'  => 'devise/sessions#destroy' #convenience
  end

  namespace :admin do
    resources :studies, :lessons
  end
  
  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
end
