class HistoriaIncidencium < ActiveRecord::Base
	belongs_to :incidencia
	belongs_to :estado_incidencia
	belongs_to :estado_apro_incis
end
