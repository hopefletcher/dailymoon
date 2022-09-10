class AddMoonPhaseImgToMoon < ActiveRecord::Migration[6.1]
  def change
    add_column :moons, :moon_phase_img, :string
  end
end
