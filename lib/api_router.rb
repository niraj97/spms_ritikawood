class ApiRouter
  def self.load
    Rails.application.routes.draw do
      root 'customers#index'
      resources :sessions, only: [:new, :create, :destroy]
      resources :users, only: [:new, :create]
      resources :customers
      resources :proposals
      resources :customers do
        get 'proposals', on: :member
      end
      $API_ACTIONS.each do |api|
        method = api[:method]
        api_name = api[:name]
        match "api/#{api_name}", to: "api##{api_name}", via: method
      end
    end
  end
end
