class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :ape_paterno
      t.string :ape_materno
      t.integer :genero_id
      t.integer :cargo_id
      t.string :usuario_login
      t.string :contrasena
      t.string :correo
      t.string :estado

      t.timestamps null: false
    end
  end
end
