class AddBackPlacketToShirts < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :back_placket, :string
  end
end
