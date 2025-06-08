class AddSleeveToShirts < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :sleeve, :string
  end
end
