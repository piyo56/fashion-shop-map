class RenameTitleColumnToBranches < ActiveRecord::Migration
  def change
    rename_column(:branches, :location, :address)
  end
end
