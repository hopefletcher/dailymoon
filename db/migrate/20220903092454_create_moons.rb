class CreateMoons < ActiveRecord::Migration[6.1]
  def change
    create_table :moons do |t|
      t.string :phase
      t.string :moonrise
      t.string :moonset
      t.string :moon_sign
      t.date :date

      t.timestamps
    end
  end
end
