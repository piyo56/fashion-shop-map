class AddPrefectureIdToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :prefecture_id, :integer
  end
end
