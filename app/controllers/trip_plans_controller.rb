class TripPlansController < ApplicationController
  include TripPlansHelper

  def index
    if current_user != nil
      redirect_to trip_plans_choose_path
    end
  end

  def choose
    if current_user != nil
      @trips = Trip.where('user_id = ?', current_user.id)
    end
  end

  def new
    @trip = Trip.new
  end

  def edit
    if current_user != nil
      @trip = Trip.find(params[:id])
    else
      redirect_to trip_plans_guest_edit_path
    end
  end

  def guest_edit
    if current_user == nil && session[:trip] != nil
      @trip = session[:trip]
    else
      redirect_to pages_home_path
    end
  end

  def create
    @trip = Trip.new(trip_params)

    process_trip_travellers(@trip, params[:trip][:traveller_csv])

    if current_user != nil
      @trip.user_id = current_user.id
      @trip.save
      redirect_to edit_trip_plan_path(@trip)
    else
      session[:trip] = @trip
      redirect_to trip_plans_guest_edit_path
    end

  end

  def update
    if current_user != nil
      @trip = Trip.find(params[:id])
      @trip.update(trip_params)
      redirect_to edit_trip_plan_path(@trip)
    else
      redirect_to new_user_session_path
    end
  end

  def guest_update
    @trip = session[:trip]
    if @trip != nil
      @trip.update(trip_params)
      redirect_to trip_plans_guest_edit_path
    else
      redirect_to trip_plans_choose_path
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    redirect_to trip_plans_choose_path
  end

  def get_travellers
    if current_user != nil
      @trip = Trip.find(params[:id])
      render json: @trip.trip_json
    else
      render json: session[:trip].trip_json
    end

  end

  def planner_output
    if current_user != nil
      @trip = Trip.find(params[:id])
    else
      redirect_to new_user_session_path
    end

    traveller_matching = TravellerMatching.new(@trip.to_object_container)
    trip_json = traveller_matching.group_travellers.to_json

    @trip.trip_json = trip_json
    @trip.save
  end

  def guest_planner_output
    @trip = session[:trip]

    traveller_matching = TravellerMatching.new(@trip.to_object_container)
    trip_json = traveller_matching.group_travellers.to_json

    @trip.trip_json = trip_json

    session[:trip] = @trip
  end

  private
  def trip_params
    params.require(:trip).permit(:destination_address, :arrival_time)
  end
end
