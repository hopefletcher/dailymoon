class Mood < ApplicationRecord
  belongs_to :user
  validates :rating, numericality: { in: 1..6 }
end
