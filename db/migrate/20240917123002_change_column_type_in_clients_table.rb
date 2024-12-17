class ChangeColumnTypeInClientsTable < ActiveRecord::Migration[7.0]
  def change
    change_column :clients, :how_did_you_learn_about_us, :string
  end
end
