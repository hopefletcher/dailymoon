require "open-uri"
puts "Cleaning database..."

Mood.destroy_all
Event.destroy_all
User.destroy_all
Moon.destroy_all

puts "Creating users..."
fakeuser1 = User.create!(email: "user@mail.com", password: "123456", first_name: "fake", last_name: "user", location: "Barcelona, Spain", birthday: "1992-06-04", zodiac_sign: "gemini", admin: true)
fakeuser2 = User.create!(email: "user2@mail.com", password: "123456", first_name: "fake2", last_name: "user2", location: "Madrid, Spain", birthday: "1985-12-19", zodiac_sign: "sagittarius", admin: false)
fakeuser3 = User.create!(email: "user3@mail.com", password: "123456",  first_name: "fake3", last_name: "user3", location: "Lisbon, Portugal", birthday: "2002-09-01", zodiac_sign: "virgo", admin: false)
fakeuser3 = User.create!(email: "user4@mail.com", password: "123456",  first_name: "fake4", last_name: "user4", location: "Alameda, California", birthday: "1990-10-31", zodiac_sign: "scorpio", admin: false)

puts "Creating 2 months of Moods..."
start_date = Date.new(2022, 8, 1)
end_date = Date.new(2022, 9, 30)
(start_date..end_date).each do |date|
  mood = Mood.new(
    rating: rand(1..5),
    journal_entry: Faker::Hipster.paragraph(sentence_count: 4),
    date: date,
    user: fakeuser1
  )
  mood.save!
end

puts "Creating 10 Events..."

10.times do
    date = (start_date..end_date).to_a.sample
    start_time = Time.new(date.year, date.month, date.day, rand(0..23), 0, 0)
    event = Event.new(
    title: Faker::Hobby.activity,
    date: date,
    start_time: start_time,
    end_time: start_time + 1.hour,
    description: Faker::Hipster.sentences(number: 1),
    location:Faker::Nation.capital_city,
    user: fakeuser1
    )
  event.save!
end



puts 'Finished!'
