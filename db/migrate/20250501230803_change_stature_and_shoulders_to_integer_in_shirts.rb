class ChangeStatureAndShouldersToIntegerInShirts < ActiveRecord::Migration[7.0]
  def change
    change_column :shirts, :stature, :integer, using: 'stature::integer'
    change_column :shirts, :shoulders, :integer, using: 'shoulders::integer'
  end
end
