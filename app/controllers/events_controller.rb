class EventsController < ApplicationController
  before_action :require_signed_in!
  before_action :find_and_set_event, only: [:show, :edit, :update, :destroy]
  
  def index
    @events = current_user.events
  end
  
  def new
    @event = current_user.events.new
    render :new
  end
  
  def show
    render :show
  end
  
  def edit
    render :edit
  end
  
  def create
    @event = current_user.events.create(event_params)
    
    if @event.save
      flash[:success] = "Event successfully created"
      redirect_to @event
    else
      flash.now[:errors] = @event.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end
  
  def update
    if @event.update(event_params)
      flash[:success] = "Event successfully updated"
      redirect_to @event
    else
      flash[:errors] = @event.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    if Event.destroy(@event)
      flash[:success] = "Event successfully deleted"
    else
      flash[:errors] = ["Error deleting event"].concat(@event.errors.full_messages)
    end
      redirect_to events_url
  end
  
  private
    def find_and_set_event
      @event = current_user.events.find(params[:id])
    end
    
    def event_params
      params.require(:event).permit(:name, :description, :location, :category, :labels, :month, :day, :year)
    end
end
