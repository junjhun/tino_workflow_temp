class AddGenderToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :gender, :integer, default: 0, null: false
  end
end
