class CalendarController < ApplicationController
  def day
    fetch_moon_data
    @moon_data = @data["days"].first
    define_moon_phase
  end

  private

  def fetch_moon_data
    require "json"
    require "open-uri"

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{current_user.location.delete(' ')}/#{Date.today}?key=#{ENV["VISUALCROSSING_KEY"]}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    data_serialized = URI.open(url).read
    @data = JSON.parse(data_serialized)
  end

  def define_moon_phase
    md = @moon_data["moonphase"]
    if md == 0 || md == 1
      @moon_phase = "New Moon"
      @moon_phase_pic = "/assets/moon1_new.png"
    elsif md < 0.25
      @moon_phase = "Waxing Crescent"
      @moon_phase_pic = "/assets/moon2_waxingcrescent.png"
    elsif md == 0.25
      @moon_phase = "First Quarter"
      @moon_phase_pic = "/assets/moon3_firstquarter.png"
    elsif md < 0.5
      @moon_phase = "Waxing Gibbous"
      @moon_phase_pic = "/assets/moon4_waxinggibbous.png"
    elsif md == 0.5
      @moon_phase = "Full Moon"
      @moon_phase_pic = "/assets/moon5_full.png"
    elsif md < 0.75
      @moon_phase = "Waning Gibbous"
      @moon_phase_pic = "/assets/moon6_waninggibbous.png"
    elsif md == 0.75
      @moon_phase = "Last Quarter"
      @moon_phase_pic = "/assets/moon7_lastquarter.png"
    else md < 1
      @moon_phase = "Waning Crescent"
      @moon_phase_pic = "/assets/moon8_waningcrescent.png"
    end
  end
end
