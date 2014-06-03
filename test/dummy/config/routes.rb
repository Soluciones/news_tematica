# coding: UTF-8

Dummy::Application.routes.draw do

  mount NewsTematica::Engine, at: "/", as: 'engine_news'
  # scope :news_tematica do
  #   resources :news_tematica
  # end
  post 'login' => 'usuarios#login', as: 'login'
  get 'usuarios/:nick_limpio' => 'usuarios#perfil', as: 'perfil'
  resources :redirections
end
