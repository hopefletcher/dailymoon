class User < ApplicationRecord
  has_many :moods
  has_many :events
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Fetches Moonsign right after User creation
  before_create :fetch_zodiac_sign

  private

  def fetch_zodiac_sign
    # First match birthday to dd-mm-yyyy (mind you the self.birthday is now of Date class)
    stripdate = self.birthday.strftime('%d-%m-%Y')
    date = stripdate.match(/(\d{2})-(\d{2})-(\d{4})/)
    # Now fetch from API
    url = 'https://json.astrologyapi.com/v1/planets'
    # This method pretty much copies what @Hope did in Calendar#Day
    results = HTTParty.post(url,
      :body => { :day => date[1],
                 :month => date[2],
                 :year => date[3],
                 :min => Time.now.min,
                 :hour => Time.now.hour,
                 :tzone => 1,
                 # We can Geocode this...
                 :lat => 41.3926679,
                 :lon => 2.1401891
               }.to_json,
      :headers => { 'Content-Type' => 'application/json' },
      :basic_auth => { :username => "620589", :password => "42167510aaf892ac7f9e0efd947fed78" })
      zodiac = results.find { |result| result["name"] == "Sun"}
      self.zodiac_sign = zodiac["sign"]
  end
end
