class AddFieldsToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :no_of_pleats, :integer, default: 0, null: false
    add_column :pants, :waist_area, :integer, default: 0, null: false
  end
end
