class RolUsuario < ActiveRecord::Base
	belongs_to :rols
	belongs_to :usuarios
end
