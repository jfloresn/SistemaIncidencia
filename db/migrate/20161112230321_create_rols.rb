class CreateRols < ActiveRecord::Migration
  def change
    create_table :rols do |t|
      t.string :codigo
      t.string :nombre
      t.string :estado

      t.timestamps null: false
    end
  end
end
