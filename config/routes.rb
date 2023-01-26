Rails.application.routes.draw do
  root 'pages#index'
  put '/add_order', to: 'order#add_order'
  get '/ordered_dishes', to: 'order#ordered_dishes'
  get '/ordered_dishes/by_date/:date', to: 'order#ordered_dishes_by_date'
  get '/ordered_dishes/by_id/:id', to: 'order#order_by_id'
end
