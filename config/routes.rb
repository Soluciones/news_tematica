NewsTematica::Engine.routes.draw do
  resources :news_tematicas do
    post :contenidos_elegidos, on: :member
    get :elegir_contenidos, on: :member
  end
end
