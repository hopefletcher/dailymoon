class Moon < ApplicationRecord

  # def fetch_moon_data
  #   require "json"
  #   require "open-uri"

  #   url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/London,UK/2022-09-03?key=#{api_key_visualcrossing}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
  #   user_serialized = URI.open(url).read
  #   user = JSON.parse(user_serialized)
  # end
end
