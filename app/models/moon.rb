class Moon < ApplicationRecord

  def fetch_moon_data
    require "json"
    require "open-uri"

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Barcelona,ES?key=R597FYUYAA9JQJRLNDNTD4C6E"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
  end
end
