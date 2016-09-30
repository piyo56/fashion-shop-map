class AddBranchIdIdToShop < ActiveRecord::Migration
  def change
    add_column :shops, :branch_id, :integer
  end
end
