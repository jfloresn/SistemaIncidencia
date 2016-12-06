class CreateUrgencia < ActiveRecord::Migration
  def change
    create_table :urgencia do |t|
      t.string :codigo
      t.string :nombre
      t.string :estado

      t.timestamps null: false
    end
  end
end
