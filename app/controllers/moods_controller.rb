class MoodsController < ApplicationController
  before_action :set_mood, only: %i[show new edit]

  def show
    @date = Date.parse(date_params)
    if @mood.nil?
      redirect_to new_mood_path(date: @date)
    else
      set_emoji
      display_emoji
    end
  end

  def new
    @date = Date.parse(params[:date])
    @mood = Mood.new(date: @date)
  end

  def create
    @mood = Mood.new(mood_params)
    @mood.user = current_user
    @mood.save!
    if @mood.save!
      redirect_to mood_path(date: @mood.date)
    else
      render :new
    end
  end

  def edit; end

  def update
    @mood = Mood.find(mood_params[:id])
    @mood.update(mood_params)
    @mood.save!
    redirect_to mood_path(date: @mood.date)
  end

  def set_emoji
    if @mood.rating == 1
      @emoji = "😢"
    elsif @mood.rating == 2
      @emoji = "💩"
    elsif @mood.rating == 3
      @emoji = "😡"
    elsif @mood.rating == 4
      @emoji = "😐"
    elsif @mood.rating == 5
      @emoji = "🥳"
    elsif @mood.rating == 6
      @emoji = "😀"
    end
  end

  private

  def display_emoji
    case @emoji
    when "😢"
      @class="sad"
    when "💩"
      @class='shit'
    when "😡"
      @class='angry'
    when "😐"
      @class='neutral'
    when "😊"
      @class='good'
    when "😀"
      @class='happy_class'
    end
  end

  def mood_params
    params.require(:mood).permit(:rating, :journal_entry, :date, :id)
  end

  def date_params
    params.require(:date)
  end

  def set_mood
    @mood = current_user.moods.find_by(date: Date.parse(date_params))
  end
end
