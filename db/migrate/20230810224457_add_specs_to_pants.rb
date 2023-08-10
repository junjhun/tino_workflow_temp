class AddSpecsToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :specs_form, :integer, default: 0, null: false
  end
end
