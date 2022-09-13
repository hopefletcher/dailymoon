class EventsController < ApplicationController
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

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_time, :end_time, :description, :location)
  end
end
