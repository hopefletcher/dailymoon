class AddColumnsToUserTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :location, :string
    add_column :users, :birthday, :date
    add_column :users, :zodiac_sign, :string
  end
end
