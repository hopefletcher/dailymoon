class ChangeDataTypeMoons < ActiveRecord::Migration[6.1]
  def change
    remove_column :moons, :moonrise, :string
    add_column :moons, :moonrise, :time
    remove_column :moons, :moonset, :string
    add_column :moons, :moonset, :time
  end
end
