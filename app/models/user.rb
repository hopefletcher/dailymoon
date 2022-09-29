class User < ApplicationRecord
  has_many :moods
  has_many :events
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Defaulting new users to admin: false
  before_create :default_admin

  # Fetches Moonsign right after User creation
  before_create :assign_zodiac_sign
  before_update :assign_zodiac_sign

  # Geocoder
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  private

  def assign_zodiac_sign
    birthday = self.birthday
    if birthday.day < 10
      birthday_day = "0" + birthday.day.to_s
    else
      birthday_day = birthday.day.to_s
    end

    bd = (birthday.month.to_s + birthday_day).to_i
    if (1221..1231).include?(bd) || (101..119).include?(bd)
      @user_zodiac_sign = "Capricorn"
    elsif (120..217).include?(bd)
      @user_zodiac_sign = "Aquarius"
    elsif (218..319).include?(bd)
      @user_zodiac_sign = "Pisces"
    elsif (320..419).include?(bd)
      @user_zodiac_sign = "Aries"
    elsif (420..520).include?(bd)
      @user_zodiac_sign = "Taurus"
    elsif (521..620).include?(bd)
      @user_zodiac_sign = "Gemini"
    elsif (621..721).include?(bd)
      @user_zodiac_sign = "Cancer"
    elsif (722..822).include?(bd)
      @user_zodiac_sign = "Leo"
    elsif (823..922).include?(bd)
      @user_zodiac_sign = "Virgo"
    elsif (923..1022).include?(bd)
      @user_zodiac_sign = "Libra"
    elsif (1023..1121).include?(bd)
      @user_zodiac_sign = "Scorpio"
    elsif (1122..1220).include?(bd)
      @user_zodiac_sign = "Sagittarius"
    else
      @user_zodiac_sign = "undefined"
    end
    self.zodiac_sign = @user_zodiac_sign
  end

  # def fetch_zodiac_sign
  #   # First match birthday to dd-mm-yyyy (mind you the self.birthday is now of Date class)
  #   stripdate = self.birthday.strftime('%d-%m-%Y')
  #   date = stripdate.match(/(\d{2})-(\d{2})-(\d{4})/)
  #   # Now fetch from API
  #   url = 'https://json.astrologyapi.com/v1/planets'
  #   # This method pretty much copies what @Hope did in Calendar#Day
  #   results = HTTParty.post(url,
  #     :body => { :day => date[1],
  #                :month => date[2],
  #                :year => date[3],
  #                :min => Time.now.min,
  #                :hour => Time.now.hour,
  #                :tzone => 1,
  #                # We can Geocode this now
  #                :lat => self.latitude,
  #                :lon => self.longitude
  #              }.to_json,
  #     :headers => { 'Content-Type' => 'application/json' },
  #     :basic_auth => { :username => ENV["ASTRO_API_USERNAME"], :password => ENV["ASTRO_API_KEY"] })
  #     zodiac = results.find { |result| result["name"] == "Sun"}
  #     self.zodiac_sign = zodiac["sign"]
  # end

  def default_admin
    self.admin ||= false
 end
end
