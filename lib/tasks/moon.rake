namespace :moon do
  desc "Saving moon data daily"
  task save: :environment do
    start_date = Moon.last.date + 1
    end_date = Date.today
    # puts start_date
    # puts end_date

    require "json"
    require "open-uri"

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Lisbon/2022-01-20/2022-01-21/?key=#{ENV["VISUALCROSSING_KEY"]}&include=days&elements=datetime,moonphase,sunrise,sunset,moonrise,moonset"
    data_serialized = URI.open(url).read
    @data = JSON.parse(data_serialized)
    @moon_data = @data["days"]
    # puts "@data: "
    # puts @data
    # puts "@moon_data: "
    # puts @moon_data

    @moon_data.each do |md|
      # p moon_phase_name
      # p moon_phase
      # p moon_phase_img
      # define_moon_phase
      define_moon_phase
      Moon.create(phase: @moon_phase, moon_phase_name: @moon_phase_name, moon_phase_img: @moon_phase_img, date: md["datetime"], moonrise: md["moonrise"], moonset: md["moonset"])
    end
  end

  private

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
