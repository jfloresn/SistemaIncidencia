class HomeController < ApplicationController
  def layout
  end
  def actualizarContrasena
	    @user = Usuario.find(params[:usuarioId])
				# Actualiza los campos de la tabla
				if @user.update_attributes(:contrasena => params[:contrasena])
						# Si esta correcto, redirecciona a la bandeja
						data = {:message => 'Se actualizo correctamente la contraseña', :success => true}
					else
						data = {:message => 'Ocurrio algo al intentar actualizar  la contraseña', :success => false}
					end
				render :json => data, :status => :ok
  end
end
