
Train01::Application.routes.draw do
  resources :shipments

  resources :prod_subtypes

  resources :logs

  resources :contract_items

  resources :contracts
  match     '/contracts/:id/add_item',                to: 'contracts#add_item',            via: :get,  as: :add_contract_item
  # The rest of queries (ship, remove_item, add_item_apply, auto_assign_item) are made through forms and address the same function.
  match     '/contracts/:id/assign_item/:item_id',    to: 'contracts#assign_item',         via: :get,  as: :assign_contract_item_product
  match     '/contracts/:id/unassign_item',           to: 'contracts#unassign_item',       via: :post, as: :unassign_contract_item
  match     '/contracts/:id/adjust',                  to: 'contracts#adjust',              via: :post, as: :adjust_contract
  match     '/date_parts_required',                   to: 'contracts#parts_required',      via: :get,  as: :date_parts_required
  match     '/contracts_update',                      to: 'contracts#contracts_update',    via: :post, as: :contracts_update
  match     '/contracts/:id/copy',                    to: 'contracts#copy',                via: :post, as: :copy_contract
  match     '/contracts/:id/packing_list',            to: 'contracts#packing_list',        via: :get,  as: :packing_list
  match     '/contracts/:id/user_packing_list',       to: 'contracts#user_packing_list',   via: :get,  as: :user_packing_list
  match     '/contracts/:id/ship_assigned_items',     to: 'contracts#ship_assigned_items', via: :post, as: :ship_assigned_items
  match     '/contracts/:id/add_attachment',          to: 'contracts#add_attachment',      via: :post, as: :contract_add_attachment


  resources :product_statuses

  resources :products
  match     '/products/:id/change_box',     to: 'products#change_box',          via: :get,  as: :change_product_box
  match     '/products/:id/change_box',     to: 'products#change_box_apply',    via: :post, as: :change_product_box_apply
  match     '/products/:id/add_attachment', to: 'products#add_attachment',      via: :post, as: :product_add_attachment
  
  resources :prod_types
  match     '/prod_types/:id/add_subtype',    to: 'prod_types#add_subtype',          via: :get,  as: :add_prod_subtype
  match     '/prod_types/:id/add_subtype',    to: 'prod_types#add_subtype_apply',    via: :post
  match     '/prod_types/:id/remove_subtype', to: 'prod_types#remove_subtype_apply', via: :post, as: :remove_prod_subtype
  match     '/prod_types/:id/adjust',         to: 'prod_types#adjust',               via: :post, as: :adjust_prod_type
  match     '/prod_types/:id/add_attachment', to: 'prod_types#add_attachment',       via: :post, as: :prod_type_add_attachment

  resources :image_to_parts

  resources :attachments

  resources :item_statuses

  resources :part_types

  resources :image_to_samples

  resources :samples
  match     'samples/:id',     to: 'samples#add_image', via: :post
  match     'samples/:id/change_box', to: 'samples#change_box',          via: :get,  as: :change_sample_box
  match     'samples/:id/change_box', to: 'samples#change_box_apply',    via: :post, as: :change_sample_box_apply

  resources :warehouses

  resources :part_insts
  match     '/part_insts/create',    to: 'part_insts#create',     via: :post, as: :create_part_inst

  resources :boxes
  match     '/boxes/:id/content',    to: 'boxes#content',         via: :get, as: :inspect_content
  match     '/boxes/:id/content',    to: 'boxes#merge_identical', via: :post, as: :merge_identical
  match     '/boxes/:id/add/:part',  to: 'boxes#add',             via: :get, as: :add_part_insts
  match     '/boxes/:id/add/:part',  to: 'boxes#add_apply',       via: :post
  match     '/boxes/:id/take/:part', to: 'boxes#take',            via: :get, as: :take_part_insts
  match     '/boxes/:id/take/:part', to: 'boxes#take_apply',      via: :post
  match     '/boxes/:id/add_new_part', to: 'boxes#add_new_part',  via: :get, as: :add_new_part_to_box
  match     '/boxes/:id/add_new_part', to: 'boxes#add_new_part_apply', via: :post

  resources :subparts

  resources :parts
  match      'parts/:id/add_subparts',     to: 'parts#add_subparts',          via: :get,  as: :add_subparts
  match      'parts/:id/add_subparts',     to: 'parts#add_subparts_apply',    via: :post
  match      'parts/:id/remove_subparts',  to: 'parts#remove_subparts',       via: :get,  as: :remove_subparts
  match      'parts/:id/remove_subparts',  to: 'parts#remove_subparts_apply', via: :post
  match      'parts/:id/estimate',         to: 'parts#estimate',              via: :get,  as: :estimate
  match      'parts/:id/estimate',         to: 'parts#estimate_take',         via: :post
  match      'parts/:id/show_production',  to: 'parts#show_production',       via: :get,  as: :show_production
  match      'parts/:id/show_production_apply', to: 'parts#show_production_apply', via: :post
  match      'parts/:id/add_image',        to: 'parts#add_image', via: :post, as: :part_add_image
  match      'parts/:id/add_attachment',   to: 'parts#add_attachment', via: :post, as: :part_add_attachment
  match      'parts/:id/copy',             to: 'parts#copy',             via: :post, as: :copy_part
  
  resources :items
  match     '/items/:id/convert_form',     to: 'items#convert_form', via: :get,  as: :convert_form
  match     '/items/:id/convert_form',     to: 'items#convert',      via: :post
  match     '/my_items',                   to: 'items#my',           via: :get,  as: :my_items
  match     '/items/:id/copy',             to: 'items#copy',         via: :get,  as: :copy_item
  match     '/items/:id/copy',             to: 'items#copy_submit',  via: :post
  
  resources :orders

  
  get "static_pages/index"
  #get 'static_pages/submit'
  match '/static_pages/submit',            to: 'static_pages#submit',            via: :post
  match '/static_pages/submitImage',       to: 'static_pages#submitImage',       via: :post
  match '/static_pages/new_user_form',     to: 'static_pages#new_user_form',     via: :get
  match '/static_pages/user_sign_in_form', to: 'static_pages#user_sign_in_form', via: :get
  match '/static_pages/user_sign_in',      to: 'static_pages#user_sign_in',      via: :post
  match '/static_pages/user_sign_out',     to: 'static_pages#user_sign_out',     via: :post
  match '/static_pages/user_register',     to: 'static_pages#user_register',     via: :post, as: :user_register

  root 'static_pages#index'

  resources :users
  match "/users",            to: "users#all",     via: :get,        as: :users_all
  get   "/users/:id"         =>  "users#show",    as:  :users_show
  get   "/users/:id/edit"    =>  "users#edit",    as:  :users_edit
  match "/users/:id/update", to: "users#update",  via: :post
  #match "/user/:id/destroy", to: "users#destroy", via: :post

  resources :orders
  match     "/orders/update", to: "orders#update",  via: :post
  get       "/my_orders"      => "orders#my_orders", as: :my_orders
  #match "/orders_all",      to: "orders#all",    via: :get
  #get   "/:id/orders/",     =>  "orders#show",   as:  :orders_show
  #get   "/orders/new"       =>  "orders#new",    as:  :users_new


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
