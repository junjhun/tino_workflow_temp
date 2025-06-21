class AddHipsToShirts < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :hips, :string
  end
end
