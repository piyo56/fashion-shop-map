class AddShopIdToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :shop_id, :integer
  end
end
