class EventsController < ApplicationController

  def index
    @datetime = DateTime.parse(date_params)
    @events = Event.where(start_time: @datetime.all_day, user_id: current_user.id).order(start_time: :asc)
  end

  def new
    @date = Date.parse(date_params)
    @datetime = DateTime.parse(date_params)
    @event = Event.new(date: @date, start_time: @datetime)
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.date = params[:date]
    @event.start_time = @event.start_time.to_datetime
    @event.end_time = @event.end_time.to_datetime
    if @event.save!
      redirect_to events_path(date: @event.date)
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
    @event = Event.find(params[:format])
    @event.destroy
    redirect_to events_path(date: params[:date])
  end

  private

  def date_params
    params.require(:date)
  end

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :description, :location, :date)
  end
end
