class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def stats
    best_phase
    poop_phase
    mad_phase
    best_sign
    moon_zodiac
    best_phase_img
    poop_phase_img
    mad_phase_img
    user_moods
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

  def moon_zodiac
    case @best_sign
    when "Aries"
      @moon_zodiac = "♈️"
    when "Taurus"
      @moon_zodiac = "♉️"
    when "Gemini"
      @moon_zodiac = "♊️"
    when "Cancer"
      @moon_zodiac = "♋️"
    when "Leo"
      @moon_zodiac = "♌️"
    when "Virgo"
      @moon_zodiac = "♍️"
    when "Libra"
      @moon_zodiac = "♎️"
    when "Scorpio"
      @moon_zodiac = "♏️"
    when "Sagittarius"
      @moon_zodiac = "♐️"
    when "Capricorn"
      @moon_zodiac = "♑️"
    when "Aquarius"
      @moon_zodiac = "♒️"
    when "Pisces"
      @moon_zodiac = "♓️"
    else
      @moon_zodiac = "🐓"
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
    moods = Mood.where(user: current_user, date: (Date.today - 7.day)..Date.today)
    @user_moods = moods.map { |mood| [mood.date.strftime("%b %d"), mood.rating] }.to_h
  end
end
