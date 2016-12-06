class AsignacionIncidenciaController < ApplicationController
  def bandeja
  end
  def grid_data

  		estadoIncidencia = EstadoIncidencium.where(:codigo => '01')

		page =  params[:page] ? (params[:page]).to_i : 1
		rp = params[:query] ? (params[:rp]).to_i : 10
		query = params[:query] ? params[:query]  : ""
		qtype = params[:qtype]
		sortname = params[:sortname]
		sortorder = params[:sortorder]

		@allIncidencia =  Incidencium.where.not(:estado_incidencia_id => estadoIncidencia.first.id)
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
             incidencia.tecnico_id as tecnicoId,
						 estado_incidencia.nombre as estadoIncidencia, 
						 estado_incidencia.codigo as codigoEstadoIncidencia, 
						 estado_apro_incis.nombre as estadoAprobIncidencia, 
						 estado_apro_incis.codigo as codigoEstadoAproIncidencia, 
			 incidencia.codigo as codigo")
		# Cuenta la cantidad de incidencias
		 count = Incidencium.where.not(:estado_incidencia_id => estadoIncidencia.first.id).count(:all)

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
                :tecnicoId => u.tecnicoId,
								:usuario => u.nombreUser,
								:codigo => u.codigo,
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
  		incidencia = Incidencium.where(:id => params[:incidenciaId])
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
  def usuarioEdit
    
  		rol = Rol.where(:codigo => '_TEC')
		 @tecnico = RolUsuario.where(:rol_id => rol.first.id)
                        .joins("INNER JOIN usuarios on usuarios.id = rol_usuarios.usuario_id")
                       .select("usuarios.id as usuarioId, 						 
             usuarios.ape_paterno || ' ' || usuarios.ape_materno || ' ' || usuarios.nombre as nombreUser")
  end
  def grabarTecnico

    # Busco el estado de incidencia y el estado de aprobacion de incidencia
  		estadoAprobIncidencia = EstadoAproInci.where(:codigo => '01')
  		estadoIncidencia = EstadoIncidencium.where(:codigo => '03')

				@incidecia = Incidencium.find(params[:incidenciaId])
				# Actualiza los campos de la tabla
				if @incidecia.update_attributes(:tecnico_id => params[:tecnicoId],
                                        :estado_incidencia_id => estadoIncidencia.first.id,
                                        :estado_apro_inci_id =>estadoAprobIncidencia.first.id)

						# Registra el historial de la incidencia
											
						historiaIncidencium = HistoriaIncidencium.new	
						historiaIncidencium.incidencia_id =  params[:incidenciaId]
						historiaIncidencium.estado_incidencia_id = estadoIncidencia.first.id
						historiaIncidencium.estado_apro_inci_id = estadoAprobIncidencia.first.id
						historiaIncidencium.fecha =  DateTime.now
						historiaIncidencium.save

						# Si esta correcto, redirecciona a la bandeja
						data = {:message => 'Se asigno correctamente el tecnico', :success => true}
					else
						data = {:message => 'Ocurrio algo al intentar asignar el tecnico', :success => false}
					end
				render :json => data, :status => :ok
  end
end
