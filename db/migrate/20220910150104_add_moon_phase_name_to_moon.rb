class AddMoonPhaseNameToMoon < ActiveRecord::Migration[6.1]
  def change
    add_column :moons, :moon_phase_name, :string
  end
end
