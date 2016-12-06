class CreateEstadoAproIncis < ActiveRecord::Migration
  def change
    create_table :estado_apro_incis do |t|
      t.string :codigo
      t.string :nombre
      t.string :estado

      t.timestamps null: false
    end
  end
end
