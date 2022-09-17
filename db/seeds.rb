require "open-uri"
puts "Cleaning database..."

Mood.destroy_all
Event.destroy_all
User.destroy_all
Moon.destroy_all

puts "Creating 4 users..."
fakeuser1 = User.create!(email: "user@mail.com", password: "123456", first_name: "fake", last_name: "user", location: "Barcelona, Spain", birthday: "1992-06-04", zodiac_sign: "gemini", admin: true)
fakeuser2 = User.create!(email: "user2@mail.com", password: "123456", first_name: "fake2", last_name: "user2", location: "Madrid, Spain", birthday: "1985-12-19", zodiac_sign: "sagittarius", admin: false)
fakeuser3 = User.create!(email: "user3@mail.com", password: "123456",  first_name: "fake3", last_name: "user3", location: "Lisbon, Portugal", birthday: "2002-09-01", zodiac_sign: "virgo", admin: false)
fakeuser4 = User.create!(email: "user4@mail.com", password: "123456",  first_name: "fake4", last_name: "user4", location: "Alameda, California", birthday: "1990-10-31", zodiac_sign: "scorpio", admin: false)

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

# puts "Creating 2 months of moons..."
# start_date = Date.new(2022, 7, 1)
# end_date = Date.new(2022, 8, 31)

# phases = ["New Moon", "Waxing Crescent Moon", "First Quarter Moon", "Waxing Gibbous Moon", "Full Moon", "Waning Gibbous Moon", "Third Quarter Moon", "Waning Crescent Moon"]

# signs = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]

# # moonrise = Time.new(date.year, date.month, date.day, rand(0..8), 0, 0)
# # moonset = Time.new(date.year, date.month, date.day, rand(0..8), 0, 0) + rand(9..12).hour

# n = 0
# (start_date..end_date).each do |date|
#     moon = Moon.new(
#       date: date,
#       phase: phases[n],
#       moonrise: Time.new(date.year, date.month, date.day, rand(14..18), 0, 0),
#       moonset: Time.new(date.year, date.month, date.day, rand(6..9), 0, 0),
#       moon_sign: signs.sample,
#       location: "Barcelona, Catalunya, Espanya"
#     )
#     moon.save!
#     if n < 7
#       n += 1
#     else
#       n = 0
#     end
# end

# # puts "Creating 1 extra moon for rake task..."
# # Moon.create(date: "2022/09/01", moonrise: "2022/09/01 00:01:00", moonset: "2022/09/01 00:02:00" , moon_sign: "FOR RAKE TASK", location: "Barcelona, Catalunya, Espanya")


puts "Importing existing moons from json file..."
# def import_moons_from_json
  file = "./db/export/moons.json"
  table_name = file.split('/').last.split('.').first
  class_type = table_name.classify.constantize
  json_file_content = File.read(file)
  if json_file_content != ''
    moons = JSON.parse(File.read(file))
    moons.each do |moon|
      moon_var = class_type.new(moon)
      moon_var.save
    end
  else
    puts "No moons saved in json file"
  end
  ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
# end


puts 'Finished!'
