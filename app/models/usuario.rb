class Usuario < ActiveRecord::Base
	has_many :rol_usuarios
	has_many :incidencia

	belongs_to :generos
	belongs_to :cargos
end
