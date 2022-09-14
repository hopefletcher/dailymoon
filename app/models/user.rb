class User < ApplicationRecord
  has_many :moods
  has_many :events
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Fetches Moonsign right after User creation
  after_create :fetch_moon_sign

  private

  def fetch_moon_sign
    url = 'https://json.astrologyapi.com/v1/planets'
    result = HTTParty.post(url,
      :body => { :day => Date.today.day,
                 :month => Date.today.month,
                 :year => Date.today.year,
                 :min => Time.now.min,
                 :hour => Time.now.hour,
                 :tzone => 1,
                 :lat => 41.3926679,
                 :lon => 2.1401891
               }.to_json,
      :headers => { 'Content-Type' => 'application/json' },
      :basic_auth => {:username => "620589", :password => "42167510aaf892ac7f9e0efd947fed78"} )
      moon = @result.find { |result| result["name"] == "Moon"}
      moon["sign"]
      @moon_sign = moon["sign"]
  end
end
