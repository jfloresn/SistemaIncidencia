Rails.application.routes.draw do

  # Rutas para login
  get 'login/index'
  post 'login/sessionIn'
  get 'login/sessionOut'

  #Ruta Dashboard
  get 'home/layout'
  post 'home/actualizarContrasena'
    
  #Acciones de controlados para Usuario
  get 'usuario/bandeja'
  get 'usuario/grid_data'
  post 'usuario/mantenimiento'
  post 'usuario/grabarDatos'
  post 'usuario/eliminarUsuario'

  #Acciones de controlados para Rol
  get 'rol/bandeja'
  get 'rol/grid_data'
  post 'rol/mantenimiento'
  post 'rol/grabarDatos'
  get 'rol/grid_data_rol_usuario'
  post 'rol/usuarioEdit'
  post 'rol/grabarDatosRolUsuario'
  post 'rol/eliminarRolUsuario'
  get 'rol/grid_data_usuario'
    
  #Acciones de controlados para Usuario
  get 'incidencia/bandeja'
  get 'incidencia/grid_data'
  post 'incidencia/mantenimiento'
  post 'incidencia/grabarDatos'
  post 'incidencia/grabarDatosSolicitud'
  post 'incidencia/historialEdit'
  get 'incidencia/grid_data_historia'
  post 'incidencia/eliminarIncidencia'
  post 'incidencia/aprobarIncidencia'
  get 'incidencia/_reporte'
  
  #Acciones de controladores para asignacion de incidencia
  get 'asignacion_incidencia/bandeja'
  get 'asignacion_incidencia/grid_data'
  post 'asignacion_incidencia/mantenimiento'
  post 'asignacion_incidencia/historialEdit'
  get 'asignacion_incidencia/grid_data_historia'
  post 'asignacion_incidencia/usuarioEdit'
  post 'asignacion_incidencia/grabarTecnico'

#Acciones de controladores para incidencias asignadas
  get 'incidencia_asignada/bandeja'
  get 'incidencia_asignada/grid_data'
  post 'incidencia_asignada/mantenimiento'
  post 'incidencia_asignada/grabarDatosAprob'
  post 'incidencia_asignada/grabarDatosDesAprob'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
 root 'login#index'
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
