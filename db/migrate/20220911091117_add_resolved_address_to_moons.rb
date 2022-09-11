class AddResolvedAddressToMoons < ActiveRecord::Migration[6.1]
  def change
    add_column :moons, :display_location, :string
  end
end
