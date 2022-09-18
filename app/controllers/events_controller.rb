class EventsController < ApplicationController

  def index
    @date = DateTime.parse(date_params)
    @events = Event.where(start_time: @date.all_day)
  end

  def new
    @date = DateTime.parse(date_params)
    @event = Event.new(start_time: @date)
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.start_time = @event.start_time.to_datetime
    @event.end_time = @event.end_time.to_datetime
    if @event.save!
      redirect_to events_path(date: @event.start_time)
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.assign_attributes(event_params)
    @event.start_time = @event.start_time.to_datetime
    @event.end_time = @event.end_time.to_datetime
    @event.save!
    redirect_to events_path(date: @event.start_time), notice: "Looks good! ✨"
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path(date: @event.start_time)
  end

  private

  def date_params
    params.require(:date)
  end

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :description, :location)
  end
end
