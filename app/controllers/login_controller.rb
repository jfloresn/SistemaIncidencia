class LoginController < ApplicationController
  def index
  end  
  def sessionOut
	    session[:usuario_id] = nil;
	    session[:usuario_login] = nil;
		  data = {:url => "/"}
	  	render :json => data, :status => :ok
	    # render 'index'
  end
  def sessionIn
		#  user = Usuario.find(1) 
		 user = Usuario.where(usuario_login: params[:codigo], contrasena: params[:contrasena], estado: 'A')
				   .joins("INNER JOIN cargos ON cargos.id = usuarios.cargo_id")
					 .select("usuarios.id as usuarioId, cargos.nombre as nombreCargo, usuarios.usuario_login as login")

		if !user.blank?
	#  if user = Usuario.joins("INNER JOIN cargos ON cargos.id = usuarios.cargo_id")
	# 	 								.select("usuarios.id as usuarioId, cargos.nombre as nombreCargo, usuarios.usuario_login as login")
	# 									.where(:usuario_login => params[:codigo], :contrasena => params[:contrasena])
		puts user.first.usuarioId
			rolUsuario =  RolUsuario.where(:usuario_id => user.first.usuarioId)
											.joins("INNER JOIN rols ON rols.id = rol_usuarios.rol_id")
											.select("rols.codigo as codigoRol")
								
		
			if !rolUsuario.blank?
					# puts user.login;
					# puts user.nombreCargo;
			
				#Los datos son correctos
					session[:usuario_id] = user.first.usuarioId;
					session[:usuario_login] = user.first.login;
					session[:cargo] = user.first.nombreCargo;
					session[:codigoRol] = rolUsuario.first.codigoRol;

		    	data = {:url => "/home/layout", :success => true}
			else
				data = {:message => "El usuario tiene asignado un rol", :success => false}
			end
	   render :json => data, :status => :ok
	 else
		   data = {:message => "Usuario y/o contraseña incorrectos", :success => false}
	   	 render :json => data, :status => :ok
    end
  end

end
