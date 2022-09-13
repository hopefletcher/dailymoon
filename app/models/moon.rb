class Moon < ApplicationRecord
  validates :date, uniqueness: { scope: :location, message: "You already saved this moon." }

end
