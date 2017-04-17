Rails.application.routes.draw do
  root 'static_pages#home'
  get ' about' => 'static_pages#about' # サイト概要ページ
  get  'inquiry'         => 'inquiry#index'     # 入力画面
  post 'inquiry/confirm' => 'inquiry#confirm'   # 確認画面
  post 'inquiry/thanks'  => 'inquiry#thanks'    # 送信完了画面
  
  get 'map'  => "shops#map"

  resources :shops, only: %i(index show)
end
