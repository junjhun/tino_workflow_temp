class AddOutseamToPants < ActiveRecord::Migration[7.0]
  def change
    remove_column :pants, :outsteam
    add_column :pants, :outseam, :string
  end
end
