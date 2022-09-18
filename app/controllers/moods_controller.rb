class MoodsController < ApplicationController
  before_action :set_mood, only: %i[show edit]

  def show
    @date = Date.parse(date_params)
    if @mood.nil?
      redirect_to new_mood_path
    else
      set_emoji
    end
  end

  def new
    @mood = Mood.new
  end

  def create
    @mood = Mood.new(mood_params)
    @mood.save
    @mood.date = Date.today
    @mood.user = current_user
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
