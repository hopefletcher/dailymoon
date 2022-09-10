class Moon < ApplicationRecord

  def fetch_moon_data
    require "json"
    require "open-uri"

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/London,UK/2022-09-03?key=#{api_key_visualcrossing}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
  end

  def fetch_moon_sign
    @url = 'https://json.astrologyapi.com/v1/planets'
    @result = HTTParty.post(@url,
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
