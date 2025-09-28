class AddReferredByToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :referred_by, :string
  end
end
