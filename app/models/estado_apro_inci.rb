class EstadoAproInci < ActiveRecord::Base
	has_many :incidencia
	has_many :historia_incidencia
end
