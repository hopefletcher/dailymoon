class CalendarController < ApplicationController
  def day
    fetch_moon_data if !Moon.last || Moon.last.date != Date.today
    # define_moon_phase
  end

  private

  def fetch_moon_data
    require "json"
    require "open-uri"

    if Moon.last
      start_date = (Moon.last.date + 1)
    else
      start_date = "2022-09-01"
    end
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{current_user.location.delete(' ')}/#{start_date}/#{Date.today}?key=#{ENV["VISUALCROSSING_KEY"]}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    data_serialized = URI.open(url).read
    @data = JSON.parse(data_serialized)
    @moon_data = @data["days"]

    if start_date.to_date - 1 < Date.today
      @moon_data.each do |md|
        define_moon_phase
        moonrise = md["datetime"] + " " + md["moonrise"]
        if md["moonset"] == nil
          moonset = "No moonset today"
        else
          moonset = md["datetime"] + " " + md["moonset"]
        end
        Moon.create(phase: @moon_phase, moon_phase_name: @moon_phase_name, moon_phase_img: @moon_phase_img, date: md["datetime"], moonrise: moonrise, moonset: moonset, location: @data["resolvedAddress"])
      end
    end
  end

  def define_moon_phase
    @moon_data.each do |md|
      @moon_phase = md["moonphase"]
      if @moon_phase == 0 || @moon_phase == 1
        @moon_phase_name = "New Moon"
        @moon_phase_img = "/assets/moon1_new.png"
      elsif @moon_phase < 0.25
        @moon_phase_name = "Waxing Crescent"
        @moon_phase_img = "/assets/moon2_waxingcrescent.png"
      elsif @moon_phase == 0.25
        @moon_phase_name = "First Quarter"
        @moon_phase_img = "/assets/moon3_firstquarter.png"
      elsif @moon_phase < 0.5
        @moon_phase_name = "Waxing Gibbous"
        @moon_phase_img = "/assets/moon4_waxinggibbous.png"
      elsif @moon_phase == 0.5
        @moon_phase_name = "Full Moon"
        @moon_phase_img = "/assets/moon5_full.png"
      elsif @moon_phase < 0.75
        @moon_phase_name = "Waning Gibbous"
        @moon_phase_img = "/assets/moon6_waninggibbous.png"
      elsif @moon_phase == 0.75
        @moon_phase_name = "Last Quarter"
        @moon_phase_img = "/assets/moon7_lastquarter.png"
      else @moon_phase < 1
        @moon_phase_name = "Waning Crescent"
        @moon_phase_img = "/assets/moon8_waningcrescent.png"
      end
    end
  end

end
