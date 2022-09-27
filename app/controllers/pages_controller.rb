class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def stats
    best_phase
    poop_phase
    mad_phase
    best_sign
    @moon_zodiac = zodiac_emoji(@best_sign.downcase)
    best_phase_img
    poop_phase_img
    mad_phase_img
    user_moods
    @mood_new_moon = mood_for(0.0)
    @mood_waxing_crescent = mood_for(0.13)
    @mood_first_quarter = mood_for(0.25)
    @mood_waxing_gibbous = mood_for(0.38)
    @mood_full_moon = mood_for(0.5)
    @mood_waning_gibbous = mood_for(0.62)
    @mood_last_quarter = mood_for(0.75)
    @mood_waning_crescent = mood_for(0.87)
  end

  private

  def best_phase
    good_moods = Mood.where(rating: 5 || 6)
    good_dates = good_moods.map do |mood|
      mood.date
    end
    good_moons = good_dates.map do |good_date|
      Moon.where(date: good_dates, location: current_user.location.delete(' ')).first.moon_phase_name
    end
    @best_phase = good_moons.tally.sort_by { |k, v| v }.reverse[0][0]
  end

  def poop_phase
    poop_moods = Mood.where(rating: 2)
    poop_dates = poop_moods.map do |mood|
      mood.date
    end
    poop_moons = poop_dates.map do |poop_date|
      Moon.where(date: poop_dates, location: current_user.location.delete(' ')).first.moon_phase_name
    end
    @poop_phase = poop_moons.tally.sort_by { |k, v| v }.reverse[0][0]
  end

  def mad_phase
    mad_moods = Mood.where(rating: 3)
    mad_dates = mad_moods.map do |mood|
      mood.date
    end
    mad_moons = mad_dates.map do |mad_date|
      Moon.where(date: mad_dates, location: current_user.location.delete(' ')).first.moon_phase_name
    end
    @mad_phase = mad_moons.tally.sort_by { |k, v| v }.reverse[0][0]
  end

  def best_sign
    good_moods = Mood.where(rating: 5 || 6)
    good_dates = good_moods.map do |mood|
      mood.date
    end
    good_moonsigns = good_dates.map do |good_date|
      Moon.where(date: good_dates, location: current_user.location.delete(' ')).first.moon_sign
    end
    @best_sign = good_moonsigns.tally.sort_by { |k, v| v }.reverse[0][0]
  end

  def zodiac_emoji(emoji)
    case emoji
    when "aries"
      "♈️"
    when "taurus"
      "♉️"
    when "gemini"
      "♊️"
    when "cancer"
      "♋️"
    when "leo"
      "♌️"
    when "virgo"
      "♍️"
    when "libra"
      "♎️"
    when "scorpio"
      "♏️"
    when "sagittarius"
      "♐️"
    when "capricorn"
      "♑️"
    when "aquarius"
      "♒️"
    when "pisces"
      "♓️"
    else
      "🐓"
    end
  end

  def best_phase_img
    good_moods = Mood.where(rating: 5 || 6)
    good_dates = good_moods.map do |mood|
      mood.date
    end
    good_moons = good_dates.map do |good_date|
      Moon.where(date: good_dates, location: current_user.location.delete(' ')).first.moon_phase_img
    end
    @best_phase_img = good_moons.tally.sort_by { |k, v| v }.reverse[0][0]
  end

  def poop_phase_img
    poop_moods = Mood.where(rating: 2)
    poop_dates = poop_moods.map do |mood|
      mood.date
    end
    poop_moons = poop_dates.map do |poop_date|
      Moon.where(date: poop_dates, location: current_user.location.delete(' ')).first.moon_phase_img
    end
    @poop_phase_img = poop_moons.tally.sort_by { |k, v| v }.reverse[0][0]
  end

  def mad_phase_img
    mad_moods = Mood.where(rating: 3)
    mad_dates = mad_moods.map do |mood|
      mood.date
    end
    mad_moons = mad_dates.map do |mad_date|
      Moon.where(date: mad_dates, location: current_user.location.delete(' ')).first.moon_phase_img
    end
    @mad_phase_img = mad_moons.tally.sort_by { |k, v| v }.reverse[0][0]
  end

  def user_moods
    moods = Mood.where(user: current_user, date: (Date.today - 6.day)..Date.today).order(:date)
    @user_moods = moods.map { |mood| [mood.date.strftime("%a"), mood.rating] }.to_h
  end

  def mood_for(moonphase)
    moods = []
    mood_ratings = []
    moons = Moon.where(phase: moonphase)
    moons.each do |moon|
      moods.push(Mood.where(user: current_user, date: moon.date).first)
    end
    moods.each do |mood|
      if !mood.nil?
      mood_ratings.push(mood.rating)
      end
    end
    @mood_rating = mood_ratings.max_by {|i| mood_ratings.count(i)}
    display_emoji
    @emoji
  end

  # def moon_chart
  #   moods = Mood.where(user: current_user)
  #   date_rates = moods.map { |mood| [mood.date, mood.rating] }.to_h
  #   @moon_rates = date_rates.map do |date_rate|
  #     [Moon.where(date: date_rate[0], location: current_user.location.delete(' ')).first.moon_phase_name, date_rate[1]]
  #   end
  # end

  # def moon_breakdown
  #   # 1. Average Mood Rating of User when the Moon is Waning Crescent
  #   waning_crescents = @moon_rates.select { |moon_rate| moon_rate[0] == "Waning Crescent" }
  #   waning_ratings = waning_crescents.map { |moon| moon[1] }
  #   @avg_waning_crescent = waning_ratings.sum / waning_ratings.count

  #   # 2. Average Mood Rating of User when the Moon is First Quarter
  #   first_quarters = @moon_rates.select { |moon_rate| moon_rate[0] == "First Quarter" }
  #   first_ratings = first_quarters.map { |moon| moon[1] }
  #   @avg_first_quarter = first_ratings.sum / first_ratings.count

  #   # 3. Average Mood Rating of User when the Moon is Waxing Gibbous
  #   waxing_gibbous = @moon_rates.select { |moon_rate| moon_rate[0] == "Waxing Gibbous" }
  #   waxing_ratings = waxing_gibbous.map { |moon| moon[1] }
  #   @avg_waxing_gibbous = waxing_ratings.sum / waxing_ratings.count

  #   # 4. Average Mood Rating of User when the Moon is Full Moon
  #   full_moons = @moon_rates.select { |moon_rate| moon_rate[0] == "Full Moon" }
  #   full_ratings = full_moons.map { |moon| moon[1] }
  #   @avg_full_moon = full_ratings.sum / full_ratings.count

  #   # 5. Average Mood Rating of User when the Moon is Waning Gibbous
  #   waning_gibbous = @moon_rates.select { |moon_rate| moon_rate[0] == "Waning Gibbous" }
  #   waning_ratings = waning_gibbous.map { |moon| moon[1] }
  #   @avg_waning_gibbous = waning_ratings.sum / waning_ratings.count

  #   # 6. Average Mood Rating of User when the Moon is Last Quarter
  #   last_quarters = @moon_rates.select { |moon_rate| moon_rate[0] == "Last Quarter" }
  #   last_ratings = last_quarters.map { |moon| moon[1] }
  #   # @avg_last_quarter = last_ratings.sum / last_ratings.count

  #   # 7. Average Mood Rating of User when the Moon is Waxing Crescent
  #   waxing_crescents = @moon_rates.select { |moon_rate| moon_rate[0] == "Waxing Crescent" }
  #   waxing_ratings = waxing_crescents.map { |moon| moon[1] }
  #   @avg_waxing_crescent = waxing_ratings.sum / waxing_ratings.count

  #   # 8. Average Mood Rating of User when the Moon is New Moon
  #   new_moons = @moon_rates.select { |moon_rate| moon_rate[0] == "New Moon" }
  #   new_ratings = new_moons.map { |moon| moon[1] }
  #   @avg_new_moon = new_ratings.sum / new_ratings.count
  # end

  # def mood_chart
  #   @mood_chart = [["Waning Crescent", @avg_waning_crescent], ["First Quarter", @avg_first_quarter], ["Waxing Gibbous", @avg_waxing_crescent], ["Full Moon", @avg_full_moon], ["Waning Gibbous", @avg_waning_gibbous],[ "Last Quarter", 0], ["Waxing Crescent", @avg_waxing_crescent], ["New Moon", @avg_new_moon]]
  # end
end
