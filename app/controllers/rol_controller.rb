class RolController < ApplicationController
  def bandeja
  end
	def grid_data

		page =  params[:page] ? (params[:page]).to_i : 1
		rp = params[:query] ? (params[:rp]).to_i : 10
		query = params[:query] ? params[:query]  : ""
		qtype = params[:qtype]
		sortname = params[:sortname]
		sortorder = params[:sortorder]

		# Busca a todos los roles
		@roles = Rol.all
		# Cuenta la cantidad de roles
		count = Rol.count(:all)

		# Contruir el formato de la grilla JQGRID
		indice = 0	
		return_data = Hash.new()
		return_data[:total] = count
		return_data[:page] = page
		return_data[:records] = count
		return_data[:rows] = @roles.collect{|u| {:id => indice+=1,:cell => {:rolId => u.id,
															   				:codigo => u.codigo,
                                                                            :nombre => u.nombre}}}

		# Convierte el formato a JSON
		render :json => return_data

	end
	def mantenimiento
		# Valida si el estado es Nuevo:1 o Editar:2
		# Si es editar, busca por el id del rol
		# @isNew, estado del mantenimiento para mostrar los campos cargados cuando sea editar
	  	@isNew = true
	  	@edit = params[:edit].strip
	  	if params[:edit].strip == "2"	
	  		@rol = Rol.find_by(:id => params[:rolId]) 
	  		@isNew = false
	  	end
	end
	def grid_data_rol_usuario

		page =  params[:page] ? (params[:page]).to_i : 1
		rp = params[:query] ? (params[:rp]).to_i : 10
		query = params[:query] ? params[:query]  : ""
		qtype = params[:qtype]
		sortname = params[:sortname]
		sortorder = params[:sortorder]

		# Busca a todos los roles
		@rolUsuario =  RolUsuario.where(:rol_id => params[:rolId]).joins("INNER JOIN usuarios ON usuarios.id = rol_usuarios.usuario_id")
										 .select("rol_usuarios.id as rolUsuarioId, usuarios.nombre as nombreUsuario,
										 		  usuarios.ape_paterno as apePaterno, usuarios.ape_materno as apeMaterno")
									     
		# Cuenta la cantidad de roles
		count = RolUsuario.where(:rol_id => params[:rolId]).count(:all)

		# Contruir el formato de la grilla JQGRID
		indice = 0	
		return_data = Hash.new()
		return_data[:total] = count
		return_data[:page] = page
		return_data[:records] = count
		return_data[:rows] = @rolUsuario.collect{|u| {:id => indice+=1,:cell => {:rolUsuarioId => u.rolUsuarioId,
																				 :nombreUsuario => u.nombreUsuario + ' ' + u.apePaterno + ' ' + u.apeMaterno}}}

		# Convierte el formato a JSON
		render :json => return_data
	end
	def grabarDatos
		if params[:edit].strip == "2"
				@rol = Rol.find(params[:rolId])
				# Actualiza los campos de la tabla
				if @rol.update_attributes(:nombre => params[:nombre], :estado => params[:estado])
					# Si esta correcto, redirecciona a la bandeja
					data = {:message => 'Se actualizo correctamente el rol',:url => "/rol/bandeja", :success => true}
				else
					data = {:message => 'Ocurrio algo al intentar actualizar el rol', :success => false}
				end
				render :json => data, :status => :ok
		elsif params[:edit].strip == "3"
			puts "Eliminar"
		else	
			puts "Otro"
		end
	end
	def grabarDatosRolUsuario
		if params[:edit].strip == "1"	
			rolUsuario = RolUsuario.find_by(:usuario_id => params[:usuarioId])

			if !rolUsuario.blank?
				data = {:message => 'El usuario ya esta registrado en un rol', :success => false}
			else
				# Creo la instancia para el nuevo rol
				rolUsuario = RolUsuario.new
				# Asigno los valores del formulario a cada campo de la tabla
				rolUsuario.usuario_id	= params[:usuarioId]
				rolUsuario.rol_id	= params[:rolId]
				# Graba los campos cargados para el rol_usuario
				if rolUsuario.save
				# Si esta correcto, redirecciona a la bandeja
					data = {:message => 'Se asigno correctamente el usuario al rol', :success => true, :data => rolUsuario.id}
				else
					data = {:message => 'Ocurrio algo al intentar registrar el rol', :success => false}
				end
			end
			render :json => data, :status => :ok
		elsif params[:edit].strip == "2"
			rolUsuario = RolUsuario.find_by(:usuario_id => params[:usuarioId])

			if !rolUsuario.blank?
				data = {:message => 'El usuario ya esta registrado en un rol', :success => false}
			else
				@rolUsuario = RolUsuario.find(params[:rolUsuarioId])
				# Actualiza los campos de la tabla
				if @rolUsuario.update_attributes(:usuario_id => params[:usuarioId])
					# Si esta correcto, redirecciona a la bandeja
					data = {:message => 'Se actualizo correctamente el usuario al rol', :success => true}
				else
					data = {:message => 'Ocurrio algo al intentar actualizar el rol', :success => false}
				end
			end
				render :json => data, :status => :ok
		elsif params[:edit].strip == "3"
			puts "Eliminar"
		else	
			puts "Otro"
		end
	end
	def grid_data_usuario

		page =  params[:page] ? (params[:page]).to_i : 1
		rp = params[:query] ? (params[:rp]).to_i : 10
		query = params[:query] ? params[:query]  : ""
		qtype = params[:qtype]
		sortname = params[:sortname]
		sortorder = params[:sortorder]

		# Busca a todos los usuarios
		@countries = Usuario.all
		puts params[:usuarioId]

		@allUser =  Usuario.where(:estado => 'A').joins("INNER JOIN generos ON generos.id = usuarios.genero_id 
		INNER JOIN cargos ON cargos.id = usuarios.cargo_id")
		.select("usuarios.id as usuarioId, 
						 usuarios.nombre as nombreUser, 
						 usuarios.ape_paterno as apePatUser, 
						 usuarios.ape_materno as apeMatUser, 
						 generos.id as generoId,
						 generos.nombre as nombreGenero, 
						 cargos.id as cargoId,
						 cargos.nombre as nombreCargo,
						 usuarios.usuario_login as login, 
						 usuarios.correo as correo, 
						 usuarios.estado as estado")

		# Cuenta la cantidad de usuarios
		count = Usuario.where(:estado => 'A').count(:all)

		# Contruir el formato de la grilla JQGRID
		indice = 0	
		return_data = Hash.new()
		return_data[:total] = count
		return_data[:page] = page
		return_data[:records] = count
		return_data[:rows] = @allUser.collect{|u| {
			:id => indice+=1,
			:cell => {
								:usuarioId => u.usuarioId,
								:nombre => u.nombreUser,
								:apePaterno => u.apePatUser,
								:apeMaterno => u.apeMatUser,
								:generoId => u.generoId,
								:nombreGenero => u.nombreGenero,
								:cargoId => u.cargoId,
								:nombreCargo => u.nombreCargo,
								:login => u.login,
								:correo => u.correo,
								:estado => u.estado
							}
					}
			}

		# Convierte el formato a JSON
		render :json => return_data

	end
	def eliminarRolUsuario
		if RolUsuario.find_by(:id => params[:rolUsuarioId]).destroy
		 	data = {:message => 'El usuario se elimino correctamente', :success => true}
		else
			data = {:message => 'Ocurrio algo al intentar actualizar el usuario', :success => false}
		end

		render :json => data, :status => :ok
	end
	def usuarioEdit
	end
end
