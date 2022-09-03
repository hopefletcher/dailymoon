require "open-uri"
puts "Cleaning database..."

User.destroy_all
Mood.destroy_all
Event.destroy_all
Moon.destroy_all

puts "Creating users..."
fakeuser1 = User.create!(email: "user@mail.com", password: "123456", first_name: "fake", last_name: "user", location: "Barcelona, Spain", birthday: "1992-06-04", zodiac_sign: "gemini", admin: true)
fakeuser2 = User.create!(email: "user2@mail.com", password: "123456", first_name: "fake2", last_name: "user2", location: "Madrid, Spain", birthday: "1985-12-19", zodiac_sign: "sagittarius", admin: false)
fakeuser3 = User.create!(email: "user3@mail.com", password: "123456",  first_name: "fake3", last_name: "user3", location: "Lisbon, Portugal", birthday: "2002-09-01", zodiac_sign: "virgo", admin: false)
fakeuser3 = User.create!(email: "user4@mail.com", password: "123456",  first_name: "fake4", last_name: "user4", location: "Alameda, California", birthday: "1990-10-31", zodiac_sign: "scorpio", admin: false)

puts "Creating Moods..."
start_date = Date.new(2022, 8, 1)
end_date = Date.new(2022, 9, 30)
(start_date..end_date).each do |date|
  mood = Mood.new(
    rating: rand(1..5),
    journal_entry: Faker::Hipster.paragraph(sentence_count: 4),
    date: date
  )
  mood.save!
end


puts 'Finished!'
