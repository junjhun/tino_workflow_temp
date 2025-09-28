class AddPleatsToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :pleats, :integer, default: 0, null: false
  end
end
