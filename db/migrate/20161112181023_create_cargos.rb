class CreateCargos < ActiveRecord::Migration
  def change
    create_table :cargos do |t|
      t.string :nombre
      t.string :estado

      t.timestamps null: false
    end
  end
end
