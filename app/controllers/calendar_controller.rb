require "json"
require "open-uri"
require "net/http"

class CalendarController < ApplicationController
  def day
    params[:date] = Date.today if params[:date].nil?
    fetch_moon_data_today if Moon.where(date: params[:date], location: current_user.location.delete(' ')) == []
    # fetch_moon_data_today if !Moon.last || Moon.last.date != params[:date].to_date || Moon.last.location != current_user.location.delete(' ')
    @daily_horoscope = daily_horoscope
  end

  # def api_call; end

  def month
    if params[:start_date] == nil
      start_date = Time.now.beginning_of_month.strftime("%Y-%m-%d")
    else
      start_date = params[:start_date]
    end
    # fetch_moon_data
    #contains treated data from fetch_moon_data from May to end of December
    file = "./db/export/moons_may_dec.json"
    json_file_content = File.read(file)
    if json_file_content != ''
      moons = JSON.parse(File.read(file))
       @current_month_moons = []
      moons.each do |moon|
        tmp_moon_month = moon["date"].split('-')[1]
        if tmp_moon_month == start_date.split('-')[1]
          # @current_month_moons.append([moon["moon_phase_name"],moon["moon_phase_img"]])
          @current_month_moons.append(moon)
        end
      end
      return @current_month_moons
    else
      puts "No moons saved in json file"
    end
    ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
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

  def fetch_moon_data_today
    # Moon.last ? start_date = (Moon.last.date) : start_date = "2022-09-14"
    if params[:date]
      start_date = params[:date].to_date - 5
      end_date = params[:date].to_date + 5
    else
      start_date = Date.today - 5
      end_date = Date.today + 5
    end

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{current_user.location.delete(' ')}/#{start_date}/#{end_date}?key=#{ENV["VISUALCROSSING_KEY"]}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    data_serialized = URI.open(url).read
    @data = JSON.parse(data_serialized)
    @moon_data = @data["days"]

    # if start_date.to_date <= params[:date].to_date
      @moon_data.each do |md|
        define_moon_phase(md)
        md["moonrise"] == nil ? moonrise = "No moonrise" : moonrise = md["datetime"] + " " + md["moonrise"]
        md["moonset"] == nil ? moonset = "No moonset" : moonset = md["datetime"] + " " + md["moonset"]
        Moon.create(phase: @moon_phase, moon_phase_name: @moon_phase_name, moon_phase_img: @moon_phase_img, date: md["datetime"], moonrise: moonrise, moonset: moonset, location: @data["address"], display_location: @data["resolvedAddress"], moon_sign: fetch_moon_sign(md["datetime"]))
      end
    # end
  end

  def define_moon_phase(day_data)
    @moon_phase = day_data["moonphase"]
    if @moon_phase == 0 || @moon_phase == 1
      @moon_phase_name = "New Moon"; @moon_phase_img = "moon1new.png"
    elsif @moon_phase < 0.25
      @moon_phase_name = "Waxing Crescent"; @moon_phase_img = "moon2waxingcrescent.png"
    elsif @moon_phase == 0.25
      @moon_phase_name = "First Quarter"; @moon_phase_img = "moon3firstquarter.png"
    elsif @moon_phase < 0.5
      @moon_phase_name = "Waxing Gibbous"; @moon_phase_img = "moon4waxinggibbous.png"
    elsif @moon_phase == 0.5
      @moon_phase_name = "Full Moon"; @moon_phase_img = "moon5full.png"
    elsif @moon_phase < 0.75
      @moon_phase_name = "Waning Gibbous"; @moon_phase_img = "moon6waninggibbous.png"
    elsif @moon_phase == 0.75
      @moon_phase_name = "Last Quarter"; @moon_phase_img = "moon7lastquarter.png"
    else @moon_phase < 1
      @moon_phase_name = "Waning Crescent"; @moon_phase_img = "moon8waningcrescent.png"
    end
  end

  def fetch_moon_sign(day)
    @url = 'https://json.astrologyapi.com/v1/planets'
    @result = HTTParty.post(@url,
      :body => { :day => day.to_date.day,
                 :month => day.to_date.month,
                 :year => day.to_date.year,
                 :min => Time.now.min,
                 :hour => Time.now.hour,
                 :tzone => 1,
                 :lat => 41.3926679,
                 :lon => 2.1401891
               }.to_json,
      :headers => { 'Content-Type' => 'application/json' },
      :basic_auth => {:username => "#{ENV["ASTRO_API_USERNAME"]}", :password => "#{ENV["ASTRO_API_KEY"]}"} )
      moon = @result.find { |result| result["name"] == "Moon"}
      @moon_sign = moon["sign"]
  end
end

#Fetches data from the API and saves Moons in the DB
# def fetch_moon_data

#     start_date = "2022-05-01"
#     end_date = "2022-12-31"
#     url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{current_user.location.delete(' ')}/#{start_date}/#{end_date}?key=#{ENV["VISUALCROSSING_KEY"]}&include=days&elements=datetime,moonphase"
#     data_serialized = URI.open(url).read
#     @data = JSON.parse(data_serialized)
#     @moon_data = @data["days"]

#     if start_date.to_date <= Date.today
#       @moon_data.each do |md|
#         moon_phase_name_resolved, moon_phase_img_resolved = get_moon_phase_name(md["moonphase"].to_f)
#         if md["moonset"] == nil
#           moonset = "No moonset today"
#         else
#           moonset = md["moonset"]
#         end
#         moonrise = md["moonrise"]
#         Moon.create(phase: @moon_phase, moon_phase_name: moon_phase_name_resolved, moon_phase_img: moon_phase_img_resolved, date: md["datetime"], moonrise: moonrise, moonset: moonset, location: @data["address"], display_location: @data["resolvedAddress"])
#       end
#     end
#   end

# # Gets moonphase value from the API and returns and array with 2 postions(moonphase_name, moonphase_img) based on value

def get_moon_phase_name(value)
  if value == 0 || value == 1
    return ["New Moon", "/assets/moon1new.png"]
  elsif value < 0.25
    return ["Waxing Crescent", "/assets/moon2waxingcrescent.png"]
  elsif value == 0.25
    return [ "First Quarter", "/assets/moon3firstquarter.png"]
  elsif value < 0.5
    return ["Waxing Gibbous", "/assets/moon4waxinggibbous.png"]
  elsif value == 0.5
    return ["Full Moon", "/assets/moon5full.png"]
  elsif value < 0.75
    return ["Waning Gibbous", "/assets/moon6waninggibbous.png"]
  elsif value == 0.75
    return ["Last Quarter", "/assets/moon7lastquarter.png"]
  else value < 1
    return ["Waning Crescent", "/assets/moon8waningcrescent.png"]
  end
end
