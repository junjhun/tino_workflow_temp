class UpdateShirtsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :back_width, :string
  end
end
