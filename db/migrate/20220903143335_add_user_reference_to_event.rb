class AddUserReferenceToEvent < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :user
  end
end
