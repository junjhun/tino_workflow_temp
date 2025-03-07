class AddVestModelToVests < ActiveRecord::Migration[7.0]
  def change
    # Check if vest_model column doesn't already exist before adding it
    unless column_exists?(:vests, :vest_model)
      add_column :vests, :vest_model, :integer, default: 0, null: false # Or whatever data type is appropriate
    end
  end
end
