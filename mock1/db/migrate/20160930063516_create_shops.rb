class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.integer :branch_num, default:0
      t.boolean :mens
      t.boolean :ladies

      t.timestamps null: false
    end
  end
end
