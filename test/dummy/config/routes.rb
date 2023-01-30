Rails.application.routes.draw do
  mount Tybo::Engine => "/tybo"
  root to: 'tybo/login#home'
end
