Rails.application.routes.draw do

  mount NewsTematica::Engine => "/news_tematica"
  match 'login' => 'usuarios#login', as: 'login'

end
