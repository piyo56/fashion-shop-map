class AddCategoryToPrefectures < ActiveRecord::Migration
  def change
    add_column :prefectures, :category, :string
  end
end
