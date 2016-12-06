class CreateIncidencia < ActiveRecord::Migration
  def change
    create_table :incidencia do |t|
      t.integer :usuario_id
      t.integer :tecnico_id
      t.datetime :fecha
      t.integer :urgencia_id
      t.string :asunto
      t.string :descripcion
      t.string :observacion
      t.integer :estado_incidencia_id
      t.integer :estado_apro_inci_id
      t.string :codigo

      t.timestamps null: false
    end
  end
end
