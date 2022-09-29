class MoodsController < ApplicationController
  before_action :set_mood, only: %i[show new edit]

  def show
    @date = Date.parse(date_params)
    if @mood.nil?
      redirect_to new_mood_path(date: @date)
    else
      @mood_rating = @mood.rating
      display_emoji
    end
  end

  def new
    @date = Date.parse(params[:date])
    @mood = Mood.new(date: @date)
  end

  def create
    params[:date] ||= params[:mood][:date]
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
    @mood.save
    if @mood.save
      redirect_to mood_path(date: @mood.date)
    else
      render :new
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
