class CreateCalendarEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :calendar_events do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.text :description

      t.timestamps
    end
  end
end
