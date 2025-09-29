class AddIsOldClientToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :is_old_client, :boolean
  end
end
