class AddStatusToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :status, :integer, null: false, default: 0
  end
end
