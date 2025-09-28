class AddDetailsToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :notch, :string
    add_column :coats, :vent, :string
    add_column :coats, :double_breasted, :string
    add_column :coats, :peak, :string
    add_column :coats, :shawl, :string
  end
end
