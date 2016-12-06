class EstadoIncidencium < ActiveRecord::Base
	has_many :incidencia
	has_many :historia_incidencia
end
