# coding: utf-8

Dummy::Application.routes.draw do

  mount NewsTematica::Engine => "/news_tematica"
  # scope :news_tematica do
  #   resources :news_tematica
  # end
  match 'login' => 'usuarios#login', as: 'login'

end
