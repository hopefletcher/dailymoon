class Moon < ApplicationRecord

  def fetch_moon_data
    require "json"
    require "open-uri"

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/[location]/[date1]/[date2]?key=YOUR_API_KEY"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
  end
end
