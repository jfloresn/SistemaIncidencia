class IncidenciaController < ApplicationController
  def bandeja
  end
  def grid_data

		page  =  params[:page] ? (params[:page]).to_i : 1
		rp    = params[:query] ? (params[:rp]).to_i : 10
		query = params[:query] ? params[:query]  : ""
		qtype = params[:qtype]
		sortname = params[:sortname]
		sortorder = params[:sortorder]

	@allIncidencia =  Incidencium.where(:usuario_id => session[:usuario_id])	
    .joins("INNER JOIN usuarios a ON a.id = incidencia.usuario_id
            LEFT JOIN usuarios b ON b.id = incidencia.tecnico_id 
		    INNER JOIN urgencia ON urgencia.id = incidencia.urgencia_id
            INNER JOIN estado_incidencia on estado_incidencia.id = incidencia.estado_incidencia_id
            INNER JOIN estado_apro_incis on estado_apro_incis.id = incidencia.estado_apro_inci_id")
	.select("incidencia.id as incidenciaId, 
             a.ape_paterno || ' ' ||  a.ape_materno || ' ' || a.nombre as nombreUser,
             b.ape_paterno || ' ' ||  b.ape_materno || ' ' || b.nombre as nombreTec,
			 incidencia.asunto as asunto,
             incidencia.fecha as fecha,
			 estado_incidencia.nombre as estadoIncidencia, 
			 estado_incidencia.codigo as codigoEstadoIncidencia, 
			 estado_apro_incis.nombre as estadoAprobIncidencia, 
			 estado_apro_incis.codigo as codigoEstadoAproIncidencia, 
			 incidencia.codigo as codigo")

		# Cuenta la cantidad de incidencias
		 count = Incidencium.where(:usuario_id => session[:usuario_id]).count(:all)

		# Contruir el formato de la grilla JQGRID
		indice = 0	
		return_data = Hash.new()
		return_data[:total] = count
		return_data[:page] = page
		return_data[:records] = count
		return_data[:rows] = @allIncidencia.collect{|u| {
			:id => indice+=1,
			:cell => {
								:incidenciaId => u.incidenciaId,
								:codigo => u.codigo,
								:usuario => u.nombreUser,
								:tecnico => u.nombreTec,
                				:fecha => u.fecha.strftime('%d/%m/%Y'),
								:asunto => u.asunto,
								:codigoEstadoIncidencia => u.codigoEstadoIncidencia,
								:estadoIncidencia => u.estadoIncidencia,
								:codigoEstadoAproIncidencia => u.codigoEstadoAproIncidencia,
								:estadoAprobIncidencia => u.estadoAprobIncidencia
							}
					}
			}

		# Convierte el formato a JSON
		render :json => return_data
  end
  def mantenimiento
	# Valida si el estado es Nuevo:1 o Editar:2
	# Si es editar, busca por el id de la incidencia
	# @isNew, estado del mantenimiento para mostrar los campos cargados cuando sea editar
  	 @isNew = true
     @urgencia = Urgencium.all

  	 usuario = Usuario.where(:id => session[:usuario_id])
     @usuario = usuario.first.ape_paterno.strip + " " + usuario.first.ape_materno.strip + " " + usuario.first.nombre.strip
  	 @edit = params[:edit].strip
  	if params[:edit].strip == "2"	
  		incidencia = Incidencium.where(:usuario_id => session[:usuario_id], :id => params[:incidenciaId])
    .joins("INNER JOIN usuarios a ON a.id = incidencia.usuario_id
		INNER JOIN urgencia ON urgencia.id = incidencia.urgencia_id")
		.select("incidencia.id as incidenciaId, 
						 a.ape_paterno || ' ' ||  a.ape_materno || ' ' || a.nombre as nombreUser,
						 incidencia.asunto as asunto,
             incidencia.fecha as fecha,
             incidencia.urgencia_id as urgenciaId,
             incidencia.descripcion as descripcion,
             incidencia.observacion as observacion")
			 
             @id = incidencia.first.incidenciaId
             @fecha = incidencia.first.fecha.strftime('%d/%m/%Y')
             @usuario = incidencia.first.nombreUser.strip
             @asunto = incidencia.first.asunto.strip
             @urgenciaId = incidencia.first.urgenciaId
             @descripcion = incidencia.first.descripcion.strip
             @observacion = incidencia.first.observacion
  		@isNew = false
  	end
  end
  def grabarDatos
    # Busco el estado de incidencia y el estado de aprobacion de incidencia
  		estadoIncidencia = EstadoIncidencium.where(:codigo => '01')
  		estadoAprobIncidencia = EstadoAproInci.where(:codigo => '01')

  	if params[:edit].strip == "1"	
		 maxIncidencia =  Incidencium.maximum("codigo")
		 if maxIncidencia.blank?
		  corre =  1
		 else
			 corre =  maxIncidencia + 1
			 end
					# Creo la instancia para el nuevo usuario
					incidencia = Incidencium.new
					# Asigno los valores del formulario a cada campo de la tabla
					incidencia.usuario_id	= params[:usuarioId]
					incidencia.fecha = params[:fecha]
					incidencia.urgencia_id = params[:urgenciaId]
					incidencia.asunto = params[:asunto]
					incidencia.descripcion = params[:descripcion]
					incidencia.estado_incidencia_id = estadoIncidencia.first.id
					incidencia.estado_apro_inci_id = estadoAprobIncidencia.first.id
					incidencia.codigo = corre.to_s.rjust(5, "0") 
					# Graba los campos cargados para la incidencia
					if incidencia.save
						
						# Registra el historial de la incidencia
											@incidenciaId = incidencia.id
						historiaIncidencium = HistoriaIncidencium.new	
						historiaIncidencium.incidencia_id =  incidencia.id
						historiaIncidencium.estado_incidencia_id = estadoIncidencia.first.id
						historiaIncidencium.estado_apro_inci_id = estadoAprobIncidencia.first.id
						historiaIncidencium.fecha = params[:fecha]
						historiaIncidencium.observacion = params[:descripcion] 
						historiaIncidencium.save
						# Si esta correcto, redirecciona a la bandeja
						data = {:message => 'Se registro correctamente la incidencia', :data => @incidenciaId, :success => true}
					else
					data = {:message => 'Ocurrio algo al intentar registrar la incidecia', :success => false}
					end
				render :json => data, :status => :ok
  	elsif params[:edit].strip == "2" 
				@incidecia = Incidencium.find(params[:incidenciaId])
				# Actualiza los campos de la tabla
				if @incidecia.update_attributes(:asunto => params[:asunto], 
																	 :descripcion => params[:descripcion], 
																	 :urgencia_id => params[:urgenciaId])
						# Si esta correcto, redirecciona a la bandeja
						data = {:message => 'Se actualizo correctamente la incidencia', :success => true}
					else
						data = {:message => 'Ocurrio algo al intentar actualizar la incidencia', :success => false}
					end
				render :json => data, :status => :ok
  	elsif params[:edit].strip == "3"
  		puts "Eliminar"
  	else	
  		puts "Otro"
  	end
  end
  def grabarDatosSolicitud

    # Busco el estado de incidencia y el estado de aprobacion de incidencia
  		estadoAprobIncidencia = EstadoAproInci.where(:codigo => '01')
  		estadoIncidencia = EstadoIncidencium.where(:codigo => '02')

				@incidecia = Incidencium.find(params[:incidenciaId])
				# Actualiza los campos de la tabla
				if @incidecia.update_attributes(
												:estado_incidencia_id => estadoIncidencia.first.id,
												:estado_apro_inci_id =>estadoAprobIncidencia.first.id)

						# Registra el historial de la incidencia
											
						historiaIncidencium = HistoriaIncidencium.new	
						historiaIncidencium.incidencia_id =  params[:incidenciaId]
						historiaIncidencium.estado_incidencia_id = estadoIncidencia.first.id
						historiaIncidencium.estado_apro_inci_id = estadoAprobIncidencia.first.id
						historiaIncidencium.fecha = params[:fecha]
						historiaIncidencium.observacion = params[:descripcion] 
						historiaIncidencium.save

						# Si esta correcto, redirecciona a la bandeja
						data = {:message => 'Se actualizo correctamente la incidencia',:url => "/incidencia/bandeja", :success => true}
					else
						data = {:message => 'Ocurrio algo al intentar actualizar la incidencia', :success => false}
					end
				render :json => data, :status => :ok
  end
  def historialEdit
    @incidenciaId = params[:incidenciaId]
  end
  def grid_data_historia

		page =  params[:page] ? (params[:page]).to_i : 1
		rp = params[:query] ? (params[:rp]).to_i : 10
		query = params[:query] ? params[:query]  : ""
		qtype = params[:qtype]
		sortname = params[:sortname]
		sortorder = params[:sortorder]

		@allHistoriaIncidencia =  HistoriaIncidencium.where(:incidencia_id => params[:incidenciaId])
    .joins("INNER JOIN estado_incidencia on estado_incidencia.id = historia_incidencia.estado_incidencia_id
    INNER JOIN estado_apro_incis on estado_apro_incis.id = historia_incidencia.estado_apro_inci_id")
		.select("historia_incidencia.id as historialIncidenciaId,
             historia_incidencia.incidencia_id as incidenciaId,
             historia_incidencia.fecha as fecha,
             historia_incidencia.observacion as observacion, 
						 estado_incidencia.nombre as estadoIncidencia, 
						 estado_apro_incis.nombre as estadoAprobIncidencia")
		# Cuenta la cantidad de incidencias
		 count = HistoriaIncidencium.where(:incidencia_id => params[:incidenciaId]).count(:all)

		# Contruir el formato de la grilla JQGRID
		indice = 0	
		return_data = Hash.new()
		return_data[:total] = count
		return_data[:page] = page
		return_data[:records] = count
		return_data[:rows] = @allHistoriaIncidencia.collect{|u| {
			:id => indice+=1,
			:cell => {
								:historialIncidenciaId => u.historialIncidenciaId,
								:incidenciaId => u.incidenciaId,
                				:fecha => u.fecha.strftime('%d/%m/%Y'),
								:estadoIncidencia => u.estadoIncidencia,
								:estadoAprobIncidencia => u.estadoAprobIncidencia,
								:observacion => u.observacion,
							}
					}
			}

		# Convierte el formato a JSON
		render :json => return_data
  end
  def eliminarIncidencia

    # Busco el estado de incidencia y el estado de aprobacion de incidencia
  		estadoIncidencia = EstadoIncidencium.where(:codigo => '05')
  		estadoAprobIncidencia = EstadoAproInci.where(:codigo => '01')

				@incidecia = Incidencium.find(params[:incidenciaId])
				# Actualiza los campos de la tabla
				if @incidecia.update_attributes(:estado_incidencia_id => estadoIncidencia.first.id)

						historiaIncidencium = HistoriaIncidencium.new	
						historiaIncidencium.incidencia_id =  params[:incidenciaId]
						historiaIncidencium.estado_incidencia_id = estadoIncidencia.first.id
						historiaIncidencium.estado_apro_inci_id = estadoAprobIncidencia.first.id
						historiaIncidencium.fecha = DateTime.now
						historiaIncidencium.observacion = 'Eliminado por usuario'
						historiaIncidencium.save

					data = {:message => 'La incidencia se elimino correctamente', :success => true}
		else
			data = {:message => 'Ocurrio algo al intentar eliminar la incidenciaId', :success => false}
		end

		render :json => data, :status => :ok
  end
  def aprobarIncidencia
    # Busco el estado de incidencia y el estado de aprobacion de incidencia
  		estadoAprobIncidencia = EstadoAproInci.where(:codigo => '04')
  		estadoIncidencia = EstadoIncidencium.where(:codigo => '04')

				@incidecia = Incidencium.find(params[:incidenciaId])
				# Actualiza los campos de la tabla
				if @incidecia.update_attributes(:estado_incidencia_id => estadoIncidencia.first.id,
												:estado_apro_inci_id =>estadoAprobIncidencia.first.id)

						# Registra el historial de la incidencia
											
						historiaIncidencium = HistoriaIncidencium.new	
						historiaIncidencium.incidencia_id =  params[:incidenciaId]
						historiaIncidencium.estado_incidencia_id = estadoIncidencia.first.id
						historiaIncidencium.estado_apro_inci_id = estadoAprobIncidencia.first.id
						historiaIncidencium.fecha = DateTime.now
						historiaIncidencium.observacion = "Se completo correctamente"
						historiaIncidencium.save

						# Si esta correcto, redirecciona a la bandeja
						data = {:message => 'Se actualizo correctamente la incidencia', :success => true}
					else
						data = {:message => 'Ocurrio algo al intentar actualizar la incidencia', :success => false}
					end
				render :json => data, :status => :ok
  end

	def _reporte
		incidencia = Incidencium.where(:usuario_id => session[:usuario_id], :id => params[:incidenciaId])
    							.joins("INNER JOIN usuarios a ON a.id = incidencia.usuario_id
										INNER JOIN urgencia ON urgencia.id = incidencia.urgencia_id
										INNER JOIN cargos ON cargos.id = a.cargo_id")	
								.select("incidencia.id as incidenciaId, 
						 				 a.ape_paterno || ' ' ||  a.ape_materno || ' ' || a.nombre as nombreUser,
						 				 incidencia.asunto as asunto,
										 incidencia.fecha as fecha,
										 incidencia.codigo as codigo,
										 incidencia.urgencia_id as urgenciaId,
										 urgencia.nombre as urgenciaNombre,
										 incidencia.descripcion as descripcion,
										 incidencia.observacion as observacion,
										 cargos.nombre as nombreCargo")

			 @id = incidencia.first.incidenciaId
			 @codigo = incidencia.first.codigo.to_s.rjust(5, "0") 
             @fecha = incidencia.first.fecha.strftime('%d/%m/%Y')
             @usuario = incidencia.first.nombreUser.strip
             @asunto = incidencia.first.asunto.strip
             @urgenciaId = incidencia.first.urgenciaId
             @descripcion = incidencia.first.descripcion.strip
             @observacion = incidencia.first.observacion
             @nombreCargo = incidencia.first.nombreCargo
             @urgenciaNombre = incidencia.first.urgenciaNombre

		@allHistoriaIncidencia =  HistoriaIncidencium.where(:incidencia_id => params[:incidenciaId])
    												 .joins("INNER JOIN estado_incidencia on estado_incidencia.id = historia_incidencia.estado_incidencia_id
    														 INNER JOIN estado_apro_incis on estado_apro_incis.id = historia_incidencia.estado_apro_inci_id")
													 .select("historia_incidencia.id as historialIncidenciaId,
															  historia_incidencia.incidencia_id as incidenciaId,
															  historia_incidencia.fecha as fecha,
															  historia_incidencia.observacion as observacion, 
						 								      estado_incidencia.nombre as estadoIncidencia, 
						  									  estado_apro_incis.nombre as estadoAprobIncidencia")

		respond_to do |format|
			format.pdf { render template: 'incidencia/_reporte', pdf: 'Reporte'}
			end
		end
end
