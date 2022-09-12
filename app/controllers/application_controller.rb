class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_theme

  def set_theme
    if params[:theme].present?
      theme = params[:theme].to_sym
      # session[:theme] = theme
      cookies[:theme] = theme
      redirect_to(request.referrer || root_path)
    end

    @zodiac_emoji = zodiac_emoji
  end

  private

  def zodiac_emoji
    if current_user
      case current_user.zodiac_sign.downcase
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
  end
end
