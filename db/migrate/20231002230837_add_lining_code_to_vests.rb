class AddLiningCodeToVests < ActiveRecord::Migration[7.0]
  def change
    add_column :vests, :lining_code, :string
  end
end
