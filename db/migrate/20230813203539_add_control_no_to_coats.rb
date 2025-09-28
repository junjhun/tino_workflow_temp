class AddControlNoToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :control_no, :string
    add_column :pants, :control_no, :string
    add_column :shirts, :control_no, :string
  end
end
