class AddFabricCodeToVests < ActiveRecord::Migration[7.0]
  def change
    add_column :vests, :fabric_code, :string
  end
end
