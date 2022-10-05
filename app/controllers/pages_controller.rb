class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home; end

  def stats
    @best_phase = mood_phase("moon_phase_name", 5, 6)
    @poop_phase = mood_phase("moon_phase_name", 2)
    @mad_phase = mood_phase("moon_phase_name", 3)
    @best_phase_img = mood_phase("moon_phase_img", 5, 6)
    @poop_phase_img = mood_phase("moon_phase_img", 2)
    @mad_phase_img = mood_phase("moon_phase_img", 3)
    @best_sign = mood_phase("moon_sign", 5, 6)
    @moon_zodiac = zodiac_emoji(@best_sign.downcase) if @best_sign
    user_moods
    @mood_new_moon = mood_for(0.0)
    @mood_first_quarter = mood_for(0.25)
    @mood_full_moon = mood_for(0.5)
    @mood_last_quarter = mood_for(0.75)
  end

  private

  def mood_phase(key, rating1, *rating2)
    # finding the dates of moods with a certain rating
    moods = Mood.where(rating: rating1, user_id: current_user.id) + Mood.where(rating: rating2, user_id: current_user.id)
    dates = moods.map do |mood|
      mood.date
    end
    # finding the moons for these dates
    moons = dates.map do |date|
      Moon.where(date: date, location: current_user.location.delete(' '))
    end
    # creating a new array with all occurances of a specific attribute (key) from these moons
    if moons != []
      result = moons.map do |moon|
        moon.first[key.to_sym]
      end
    # counting each occurence, sorting them by the most occuring value and returning this value
      result.tally.sort_by { |k, v| v }.reverse[0][0]
    end
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
