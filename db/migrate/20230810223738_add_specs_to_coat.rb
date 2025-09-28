class AddSpecsToCoat < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :specs_form, :integer, default: 0, null: false
  end
end
