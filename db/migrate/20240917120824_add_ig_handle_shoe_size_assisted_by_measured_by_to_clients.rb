class AddIgHandleShoeSizeAssistedByMeasuredByToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :IG_handle, :string 
    add_column :clients, :shoe_size, :float
    add_column :clients, :assisted_by, :string
    add_column :clients, :measured_by, :string
  end
end
