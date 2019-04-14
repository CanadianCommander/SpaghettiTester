Rails.application.routes.draw do
  get '/', to: "home#index"
  get '/index' => redirect('/')

  post '/dotest', to: 'home#dotest'
  post '/updateTestStatus', to: "home#updateTestStatus"
end
