class AddDateOfBirthAndMembershipDateToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :date_of_birth, :date
    add_column :clients, :membership_date, :date
  end
end
