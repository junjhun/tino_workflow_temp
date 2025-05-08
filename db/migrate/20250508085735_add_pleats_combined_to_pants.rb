class AddPleatsCombinedToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :pleats_combined, :integer, default: 0
  end
end
