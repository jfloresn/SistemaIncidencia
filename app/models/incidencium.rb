class Incidencium < ActiveRecord::Base
    belongs_to :usuarios
	belongs_to :urgencia
	belongs_to :estado_incidencia
	belongs_to :estado_apro_incis
    
	has_many :historia_incidencia
end
