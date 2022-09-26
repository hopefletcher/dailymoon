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
    @mood.save
    if @mood.save
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

  private

  def set_emoji
    case @mood.rating
    when 1
      @emoji = "😢"
    when 2
      @emoji = "💩"
    when 3
      @emoji = "😡"
    when 4
      @emoji = "😐"
    when 5
      @emoji = "😊"
    when 6
      @emoji = "😀"
    end
  end

  def display_emoji
    case @emoji
    when "😢"
      @emoji_class='sad'
    when "💩"
      @emoji_class='shit'
    when "😡"
      @emoji_class='angry'
    when "😐"
      @emoji_class='neutral'
    when "😊"
      @emoji_class='good'
    when "😀"
      @emoji_class='happy'
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
