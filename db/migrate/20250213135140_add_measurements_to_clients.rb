class AddMeasurementsToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :chest, :string
    add_column :clients, :back_width, :string
    add_column :clients, :waist, :string
    add_column :clients, :crotch, :string
    add_column :clients, :thigh, :string
    add_column :clients, :seat, :string
    add_column :clients, :hips, :string
    add_column :clients, :linkedin_handle, :string
    add_column :clients, :viber_handle, :string
  end
end
