class CreateGeneros < ActiveRecord::Migration
  def change
    create_table :generos do |t|
      t.string :codigo
      t.string :nombre
      t.string :estado

      t.timestamps null: false
    end
  end
end
