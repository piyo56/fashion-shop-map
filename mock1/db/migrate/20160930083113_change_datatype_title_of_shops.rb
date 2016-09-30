class ChangeDatatypeTitleOfShops < ActiveRecord::Migration
  def change
    change_column_default :shops, :branch_num, 0
  end
end
