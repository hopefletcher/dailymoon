class Mood < ApplicationRecord
  belongs_to :user
  validates :rating, numericality: { in: 1..6 }, presence: true, allow_blank: false
  validates :journal_entry, presence: true, allow_blank: false
end
