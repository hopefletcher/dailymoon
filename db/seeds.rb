require "open-uri"
require "faker"
puts "Cleaning database..."

User.destroy_all
Mood.destroy_all
Event.destroy_all
Moon.destroy_all

puts "Creating users..."
fakeuser1 = User.create!(email: "user@mail.com", password: "123456", first_name: "fake", last_name: "user", location: "Barcelona, Spain", birthday: "1992-06-04", zodiac_sign: "gemini")
fakeuser2 = User.create!(email: "user2@mail.com", password: "123456", first_name: "fake2", last_name: "user2", location: "Madrid, Spain", birthday: "1985-12-19", zodiac_sign: "sagittarius")
fakeuser3 = User.create!(email: "user3@mail.com", password: "123456",  first_name: "fake3", last_name: "user3", location: "Lisbon, Portugal", birthday: "2002-09-01", zodiac_sign: "virgo")
fakeuser3 = User.create!(email: "user4@mail.com", password: "123456",  first_name: "fake4", last_name: "user4", location: "Alameda, California", birthday: "1990-10-31", zodiac_sign: "scorpio")

puts "Creating Moods..."
# t.integer "rating"
# t.text "journal_entry"
# t.date "date"
# t.bigint "user_id", null: false
60.times do
  mood = Mood.new(
    rating: rand(1..5),
    journal_entry: "#{Faker::Address.street_address}, #{Faker::Address.city}",
    date: rand(0..5)
  )
  restaurant.save!
end
puts 'Finished!'
