class RemoveCategoryToPrefectures < ActiveRecord::Migration
  def change
    remove_column :prefectures, :category, :string
  end
end
