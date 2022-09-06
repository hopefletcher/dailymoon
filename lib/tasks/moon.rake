require_relative '../../.api_key.rb'

namespace :moon do
  desc "Saving moon data daily"
  task save_moons: :environment do
    start_date = Moon.last.date + 1
    end_date = Date.today
    puts start_date
    puts end_date

    require "json"
    require "open-uri"

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Lisbon/#{start_date}/#{end_date}/?key=#{$api_key_visualcrossing}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    data_serialized = URI.open(url).read
    @data = JSON.parse(data_serialized)
    @moon_data = @data["days"]
    puts "@data: "
    puts @data
    puts "@moon_data: "
    puts @moon_data
    @moon_data.each do |md|
      Moon.create(phase: md["moonphase"], date: md["datetime"], moonrise: md["moonrise"], moonset: md["moonset"])
    end
  end
end
