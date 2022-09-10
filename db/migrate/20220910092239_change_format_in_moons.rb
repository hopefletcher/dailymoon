class ChangeFormatInMoons < ActiveRecord::Migration[6.1]
  def change
    remove_column :moons, :moonrise, :time
    add_column :moons, :moonrise, :datetime
    remove_column :moons, :moonset, :time
    add_column :moons, :moonset, :datetime
  end
end
