class EventsController < ApplicationController
  def index
    @upcoming_events = Event.upcoming_events
  end
  
  def past_events
    @past_events = Event.past_events
  end

  def new
    @event = Event.new
  end
  
  def create
    # @user = current_user
    @event = current_user.events.build(event_params)
    if @event.save
      flash[:success] = "Event successfully created"
      redirect_to current_user
    else
      flash.now[:danger] = "The event could not be saved."
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    @attendees = @event.attendees
  end
  
  def attend
    @user      = current_user
    @event     = Event.find(params[:id])
    @attendees = @event.attendees.pluck(:attendee_id)
    @attendees << @user.id
    @event.attendee_ids = @attendees.uniq
    flash.now[:success] = "You've signed up for the event"
    redirect_to current_user
  end
  
  def unattend
    @user      = current_user
    @event     = Event.find(params[:id])
    @attendees = @event.attendees
    if @attendees.delete(@user)
      flash.now[:succes] = "You've cancelled your signup for the event"
      redirect_to current_user
    else
      redirect_to events_path
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      flash.now[:notice] = "Event deleted"
      redirect_to current_user
    else
      redirect_to current_user
    end
  end
  
  private
  
    def event_params
      params.require(:event)
            .permit(:name, :date, :description)
    end
end
