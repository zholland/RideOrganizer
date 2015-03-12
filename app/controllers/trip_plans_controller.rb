require_relative '../../app/classes/csv_input'

#require 'helpers/trip_plans_helper'

class TripPlansController < ApplicationController


  def choose
  end

  def new
  end

  def create

    #process_trip_input
  end

  def get_travellers
    trip = session[:trip]
    session[:trip] = nil

    render json: trip
  end

  def planner_output
  end
end
