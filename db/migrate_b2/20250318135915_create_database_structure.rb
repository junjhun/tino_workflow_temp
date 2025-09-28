class CreateDatabaseStructure < ActiveRecord::Migration[7.0]
  def change
    create_table :database_structures do |t|

      t.timestamps
    end
  end
end
