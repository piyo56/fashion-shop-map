class AddRegionToPrefectures < ActiveRecord::Migration
  def change
    add_column :prefectures, :region, :string
  end
end
