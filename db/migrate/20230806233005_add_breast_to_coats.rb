class AddBreastToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :breast, :integer, null: false, default: 0
  end
end
