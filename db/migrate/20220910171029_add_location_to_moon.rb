class AddLocationToMoon < ActiveRecord::Migration[6.1]
  def change
    add_column :moons, :location, :string
  end
end
