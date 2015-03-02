include PagesHelper

class PagesController < ApplicationController
  def home
  end

  def about
  end

  def planner_output
  end

  def trip_planner
  end

  def get_travellers
    render json: session[:trip].to_json
  end
end
