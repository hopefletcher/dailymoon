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
    if @event.save
      redirect_to event_path
    else
      render :new
    end
  end

  private

  def event_params

  end
end
