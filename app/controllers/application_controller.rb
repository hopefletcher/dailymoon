class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_theme
  # Setting up additional sign up fields for Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_theme
    if params[:theme].present?
      theme = params[:theme].to_sym
      # session[:theme] = theme
      cookies[:theme] = theme
      redirect_to(request.referrer || root_path)
    end

    current_user ? @zodiac_emoji = zodiac_emoji(current_user.zodiac_sign.downcase) : "🐓"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:location, :birthday, :zodiac_sign, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:location, :birthday, :first_name, :last_name])
  end

  private

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
end
