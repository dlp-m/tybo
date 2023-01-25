Rails.application.routes.draw do
  mount Tybo::Engine => "/"
  root to: 'login#home'
end
