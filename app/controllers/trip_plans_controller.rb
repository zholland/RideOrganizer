class TripPlansController < ApplicationController
  include TripPlansHelper

  def choose
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)

    process_trip_travellers(@trip, params[:trip][:traveller_csv])

    puts @trip.save
    redirect_to pages_home_path
    # process_trip_input(@trip, csv_file, destination_address, year, month, day, hour, minute)
  end

  def get_travellers
    trip = session[:trip]
    session[:trip] = nil

    render json: trip
  end

  def planner_output
  end

  private
  def trip_params
    params.require(:trip).permit(:destination_address,:arrival_time)
  end
end
