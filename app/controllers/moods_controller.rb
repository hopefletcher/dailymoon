class MoodsController < ApplicationController
  def show
    if set_mood
      set_emoji
    else
      redirect_to new_mood_path
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
      redirect_to mood_path
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
    # Line above is not completely right, we'll need logic to see if Today's mood was inputted
    @mood = current_user.moods.order("created_at").find { |mood| mood.date = Date.today }
  end
end
