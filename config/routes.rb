require "resque_web"

Rails.application.routes.draw do
	mount ResqueWeb::Engine => "/resque_web"

	get '404', to: 'errors#page_not_found'
	get '500', to: 'errors#something_went_wrong'
	get 'throw_error', to: 'errors#throw_error'

	devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', passwords: 'users/passwords', registrations: 'users/registrations', sessions: 'users/sessions' }
	devise_for :admin_users, path: '/admin', controllers: { passwords: 'admin_users/passwords', sessions: 'admin_users/sessions' }

	root 'home#index'

	# for showing modelers a scaled back modeling project
	resources :modelers, only: [:show, :create] do
		get :annotate, on: :member
		get :download_upload, on: :member
	end

	resources :scanning_projects, except: :index, param: :slug
	resources :modeling_projects, except: :index, param: :slug
	resources :printing_projects, except: :index, param: :slug do
		put :decrement_quantity, on: :member
		put :increment_quantity, on: :member
	end
	resources :projects, param: :slug, only: [:show, :new]
	resources :comments, only: :create
	resources :uploads, only: [:create, :update, :destroy, :show] do
		get :upload_ready, on: :member
		get :download, on: :member
		get :annotate, on: :member
		post :update_annotations, on: :member
		put :clone, on: :member
		post :nexus, on: :member
		post :smoothing, on: :member
	end
	resources :quotes, only: [:create, :update, :show, :new]
	resources :users, only: :update do
		get :enter_name, on: :collection
	end
	resources :orders, only: [:create, :index]

	get :beta_login, to: 'home#beta_login'
	post :beta_login_submit, to: 'home#beta_login_submit'

	get 'dashboard', to: 'dashboard#index'
	post 'search_projects', to: 'dashboard#search_projects'

	get 'terms-and-conditions', to: 'home#terms_and_conditions'
	get 'about-us', to: 'home#about_us'
	get 'faq', to: 'home#faq'
	get 'how-it-works', to: 'home#how_it_works'
	get 'materials', to: 'home#materials'
	get 'material-list', to: 'home#materials'
	get 'style-guide', to: 'style_guide#style_guide'

	get 'cart', to: 'cart#index'
	get 'viewer-from-quote', to: 'quotes#viewer_from_quote'

	namespace :admin do
		root 'dashboard#index'
		get 'dashboard', to: 'dashboard#index'

		resources :admin_users
		resources :users, only: [:index, :show]
		resources :materials, except: :destroy
		resources :workspaces
		resources :scanning_projects, param: :slug
		resources :modeling_projects, param: :slug do
			put :new_modeling_project_version, on: :member
			put :remove_pricing_group, on: :member
		end
		resources :printing_projects, param: :slug
		resources :projects, param: :slug, only: [:index, :show]
		resources :uploads do
			get :printing_prices, on: :member
			get :download, on: :member
			get :annotate, on: :member
			put :clone, on: :member
			post :upload_printing_price_upload, on: :collection
			post :update_annotations, on: :member
		end
		resources :comments
	end
end
