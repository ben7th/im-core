require 'sidekiq/web'

Rails.application.routes.draw do
  # (获取token+文件上传路径)
  mount FilePartUpload::Engine => '/file_part_upload', :as => 'file_part_upload'
  # 即时消息
  mount ActionCable.server => '/cable'

  # 队列
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root to: 'index#index'
  
  namespace :admin do
    resources :users do
      post :do_sign_in, on: :collection
      post :do_sign_out, on: :collection
      post :update_user, on: :collection
      get :get_user_detail, on: :collection
    end
    resources :organizations do
      get :tree_show, on: :collection
    end
    resources :faqs do 
      get :get_faq_detail, on: :collection
    end

    resources :references do
      get :get_ref_detail, on: :collection
      get :fetch_ref_file, on: :collection
    end

    resources :tags
    resources :questions do
      get :multi_new, on: :collection
      get :bool_new, on: :collection
    end
    resources :save_files, path: 'files' do
      get  :upload, on: :collection
      post :antd_check_uniq, on: :collection
      post :antd_check_name_present, on: :collection

    end
  end

  resources :admin

  resources :organizations do
    get :trees, on: :collection
    get :show_tree, on: :member
  end

  resources :chat_messages do
    get :history, on: :collection
  end

  get '/chat/:oid', to: 'chat#show', as: :chat
end
