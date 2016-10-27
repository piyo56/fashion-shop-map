class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.integer :branches_count, default: 0

      t.timestamps null: false
    end
  end
end
