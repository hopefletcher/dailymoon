class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.date :date
      t.string :title
      t.time :start_time
      t.time :end_time
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
