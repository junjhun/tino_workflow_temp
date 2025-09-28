class AddTypeOfPocketToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :type_of_pocket, :integer, default: 0, null: false
  end
end
