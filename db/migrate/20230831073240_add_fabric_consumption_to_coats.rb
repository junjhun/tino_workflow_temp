class AddFabricConsumptionToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :fabric_consumption, :string
    add_column :pants, :fabric_consumption, :string
    add_column :shirts, :fabric_consumption, :string
    add_column :vests, :fabric_consumption, :string
  end
end
