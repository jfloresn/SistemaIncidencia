class CreateEstadoIncidencia < ActiveRecord::Migration
  def change
    create_table :estado_incidencia do |t|
      t.string :codigo
      t.string :nombre
      t.string :estado

      t.timestamps null: false
    end
  end
end
