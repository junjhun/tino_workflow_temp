class AddFrontPlacketToShirts < ActiveRecord::Migration[7.0]
  def change
    remove_column :shirts, :placket
    add_column :shirts, :front_placket, :integer, default: 0, null: false
    add_column :shirts, :side_placket, :integer, default: 0, null: false
  end
end
