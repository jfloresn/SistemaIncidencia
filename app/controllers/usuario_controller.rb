class UsuarioController < ApplicationController
  def bandeja
  end
	def grid_data

		page =  params[:page] ? (params[:page]).to_i : 1
		rp = params[:query] ? (params[:rp]).to_i : 10
		query = params[:query] ? params[:query]  : ""
		qtype = params[:qtype]
		sortname = params[:sortname]
		sortorder = params[:sortorder]

		# Busca a todos los usuarios
		@countries = Usuario.all
		puts params[:usuarioId]

		@allUser =  Usuario.joins("INNER JOIN generos ON generos.id = usuarios.genero_id 
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
						 usuarios.estado as estado  ")

		# Cuenta la cantidad de usuarios
		count = Usuario.count(:all)

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
  def mantenimiento
	# Valida si el estado es Nuevo:1 o Editar:2
	# Si es editar, busca por el id del usuario
	# @isNew, estado del mantenimiento para mostrar los campos cargados cuando sea editar
  	 @isNew = true
     @genero = Genero.all
     @cargo = Cargo.all
  	 @edit = params[:edit].strip
  	if params[:edit].strip == "2"	
  		@user = Usuario.find_by(:id => params[:usuarioId]) 
  		@isNew = false
  	end
  end
  def grabarDatos
  	if params[:edit].strip == "1"	
  		# Verifico si el codigo ingresado ya existe
  		if user = Usuario.find_by(:usuario_login => params[:usuario]) 
					data = {:message => 'El usuario ingresado ya se encuentra registrado', :success => false}
					render :json => data, :status => :ok
			else
					# Creo la instancia para el nuevo usuario
					user = Usuario.new
					# Asigno los valores del formulario a cada campo de la tabla
					user.nombre	= params[:nombre]
					user.ape_paterno = params[:apePat]
					user.ape_materno = params[:apeMat]
					user.genero_id = params[:generoId]
					user.cargo_id = params[:cargoId]
					user.usuario_login = params[:usuario]
					user.contrasena = params[:contrasena]
					user.correo = params[:correo]
					user.estado = params[:estado]
					# Graba los campos cargados para el usuario
					if user.save
						# Si esta correcto, redirecciona a la bandeja
					data = {:message => 'Se registro correctamente el usuario',:url => "/usuario/bandeja", :success => true}
					else
					data = {:message => 'Ocurrio algo al intentar registrar el usuario', :success => false}
					end
				render :json => data, :status => :ok
				end
  	elsif params[:edit].strip == "2"
		  puts params[:usuarioId]
	  user = Usuario.where.not(:id => params[:usuarioId]).find_by(:usuario_login => params[:usuario])	 
	  		# valida si el usuario existe
			if !user.blank?
				data = {:message => 'El usuario ingresado ya se encuentra registrado', :success => false}
				render :json => data, :status => :ok
			else
				@user = Usuario.find(params[:usuarioId])
				# Actualiza los campos de la tabla
				if @user.update_attributes(:nombre => params[:nombre], 
																	 :ape_paterno => params[:apePat], 
																	 :ape_materno => params[:apeMat], 
																	 :genero_id => params[:generoId],
																	 :cargo_id => params[:cargoId], 
																	 :usuario_login => params[:usuario], 
																	 :contrasena => params[:contrasena], 
																	 :correo => params[:correo], 
																	 :estado => params[:estado])
						# Si esta correcto, redirecciona a la bandeja
						data = {:message => 'Se actualizo correctamente el usuario',:url => "/usuario/bandeja", :success => true}
					else
						data = {:message => 'Ocurrio algo al intentar actualizar el usuario', :success => false}
					end
				render :json => data, :status => :ok
			end
  	elsif params[:edit].strip == "3"
  		puts "Eliminar"
  	else	
  		puts "Otro"
  	end
  end
	def eliminarUsuario

		@usuario = Usuario.find(params[:usuarioId])
				# Actualiza los campos de la tabla
		if @usuario.update_attributes(:estado => "I")
		 	data = {:message => 'El usuario se elimino correctamente', :success => true}
		else
			data = {:message => 'Ocurrio algo al intentar eliminar el usuario', :success => false}
		end

		render :json => data, :status => :ok
	end
end
