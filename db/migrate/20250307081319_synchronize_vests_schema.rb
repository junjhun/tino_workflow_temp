class SynchronizeVestsSchema < ActiveRecord::Migration[7.0]
  def change
    # Add columns that might be missing in test (Heroku)
    add_column :vests, :fabric_label, :integer unless column_exists?(:vests, :fabric_label)
    add_column :vests, :lapel_width, :string unless column_exists?(:vests, :lapel_width)
    add_column :vests, :fabric, :integer unless column_exists?(:vests, :fabric)
    
    # Add columns that might be missing in local
    add_column :vests, :vest_style, :string unless column_exists?(:vests, :vest_style)
    
    # Fix the side_pocket data type issue if needed (only run on Heroku)
    # This is trickier - we'll need to check the column type
    reversible do |dir|
      dir.up do
        if column_exists?(:vests, :side_pocket)
          column_type = connection.columns(:vests).find { |c| c.name == 'side_pocket' }.type
          if column_type == :string || column_type == :text
            # This migration for changing column type only needs to run on Heroku
            rename_column :vests, :side_pocket, :side_pocket_old
            add_column :vests, :side_pocket, :integer
            execute("UPDATE vests SET side_pocket = CAST(side_pocket_old AS integer) WHERE side_pocket_old ~ '^[0-9]+$'")
            remove_column :vests, :side_pocket_old
          end
        else
          add_column :vests, :side_pocket, :integer
        end
      end
    end
  end
end
