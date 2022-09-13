require "json"
require "open-uri"
require "net/http"

class CalendarController < ApplicationController
  def day
    fetch_moon_data if !Moon.last || Moon.last.date != Date.today || Moon.last.location != current_user.location.delete(' ')
    fetch_moon_sign
    @daily_horoscope = daily_horoscope
  end

  private

  def daily_horoscope
    # https://github.com/sameerkumar18/aztro
    uri = URI.parse("https://aztro.sameerkumar.website/?sign=#{current_user.zodiac_sign}&day=today")
    request = Net::HTTP::Post.new(uri)

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    your_day = JSON.parse response.body.gsub('=>', ':')
    your_day["description"]
  end

  def fetch_moon_data
    if Moon.last
      start_date = (Moon.last.date)
    else
      start_date = "2022-09-01"
    end
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{current_user.location.delete(' ')}/#{start_date}/#{Date.today}?key=#{ENV["VISUALCROSSING_KEY"]}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    data_serialized = URI.open(url).read
    @data = JSON.parse(data_serialized)
    @moon_data = @data["days"]

    if start_date.to_date <= Date.today
      @moon_data.each do |md|
        define_moon_phase
        moonrise = md["datetime"] + " " + md["moonrise"]
        if md["moonset"] == nil
          moonset = "No moonset today"
        else
          moonset = md["datetime"] + " " + md["moonset"]
        end
        Moon.create(phase: @moon_phase, moon_phase_name: @moon_phase_name, moon_phase_img: @moon_phase_img, date: md["datetime"], moonrise: moonrise, moonset: moonset, location: @data["address"], display_location: @data["resolvedAddress"])
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
