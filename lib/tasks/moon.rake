# require_relative '../../app/controllers/calendar_controller'

namespace :moon do
  desc "Saving moon data daily"
  task save: :environment do
    start_date = Moon.last.date + 1
    end_date = Date.today
    location = "Lisbon"

    require "json"
    require "open-uri"

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{location}}/#{start_date}/#{end_date}/?key=#{ENV["VISUALCROSSING_KEY"]}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    data_serialized = URI.open(url).read
    @data = JSON.parse(data_serialized)
    @moon_data = @data["days"]

    @moon_data.each do |md|
      define_moon_phase
      Moon.create(phase: @moon_phase, moon_phase_name: @moon_phase_name, moon_phase_img: @moon_phase_img, date: md["datetime"], moonrise: md["moonrise"], moonset: md["moonset"], location: @data["resolvedAddress"])
    end
  end

  private

  def define_moon_phase
    @moon_data.each do |md|
      @moon_phase = md["moonphase"]
      if @moon_phase == 0 || @moon_phase == 1
        @moon_phase_name = "New Moon"
        @moon_phase_img = "/assets/moon1new.png"
      elsif @moon_phase < 0.25
        @moon_phase_name = "Waxing Crescent"
        @moon_phase_img = "/assets/moon2waxingcrescent.png"
      elsif @moon_phase == 0.25
        @moon_phase_name = "First Quarter"
        @moon_phase_img = "/assets/moon3firstquarter.png"
      elsif @moon_phase < 0.5
        @moon_phase_name = "Waxing Gibbous"
        @moon_phase_img = "/assets/moon4waxinggibbous.png"
      elsif @moon_phase == 0.5
        @moon_phase_name = "Full Moon"
        @moon_phase_img = "/assets/moon5full.png"
      elsif @moon_phase < 0.75
        @moon_phase_name = "Waning Gibbous"
        @moon_phase_img = "/assets/moon6waninggibbous.png"
      elsif @moon_phase == 0.75
        @moon_phase_name = "Last Quarter"
        @moon_phase_img = "/assets/moon7lastquarter.png"
      else @moon_phase < 1
        @moon_phase_name = "Waning Crescent"
        @moon_phase_img = "/assets/moon8waningcrescent.png"
      end
    end
  end

end
