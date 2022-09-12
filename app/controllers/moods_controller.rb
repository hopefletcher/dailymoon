class MoodsController < ApplicationController
  def show
    set_mood
    set_emoji
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
      redirect_to moods_path
    else
      render :new
    end
  end

  def edit
    set_mood
  end

  def update
    set_mood
    @mood.update(mood_params)
    redirect_to mood_path
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
    params.require(:mood).permit(:rating, :journal_entry, :date)
  end

  def set_mood
    @mood = Mood.order(created_at: :desc).find { |mood| mood.user = current_user }
  end
end
