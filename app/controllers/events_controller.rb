class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy]

  def index
    @events = Event.where(:date => Date.today)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.date = Date.today
    @event.user = current_user
    @event.save!
    if @event.save!
      redirect_to events_path
    else
      render :new
    end
  end

  def edit; end

  def update
    @event.update(event_params)
    redirect_to events_path, notice: "Looks good! ✨"
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :description, :location)
  end
end
