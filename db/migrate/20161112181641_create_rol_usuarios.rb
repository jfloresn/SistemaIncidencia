class CreateRolUsuarios < ActiveRecord::Migration
  def change
    create_table :rol_usuarios do |t|
      t.integer :rol_id
      t.integer :usuario_id

      t.timestamps null: false
    end
  end
end
