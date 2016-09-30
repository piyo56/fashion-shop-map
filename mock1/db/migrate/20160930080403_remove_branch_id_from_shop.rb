class RemoveBranchIdFromShop < ActiveRecord::Migration
  def change
    remove_column :shops, :branch_id, :integer
  end
end
