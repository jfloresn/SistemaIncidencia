class CreateHistoriaIncidencia < ActiveRecord::Migration
  def change
    create_table :historia_incidencia do |t|
      t.integer :incidencia_id
      t.integer :estado_incidencia_id
      t.integer :estado_apro_inci_id
      t.datetime :fecha
      t.string :observacion

      t.timestamps null: false
    end
  end
end
