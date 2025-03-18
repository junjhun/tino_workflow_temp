class AddShirtLengthToShirts < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :shirt_length, :string
  end
end
