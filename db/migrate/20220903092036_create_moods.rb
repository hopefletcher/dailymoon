class CreateMoods < ActiveRecord::Migration[6.1]
  def change
    create_table :moods do |t|
      t.integer :rating
      t.text :journal_entry
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
