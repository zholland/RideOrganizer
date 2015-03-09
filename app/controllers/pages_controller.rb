include PagesHelper

class PagesController < ApplicationController
  def home
  end

  def about
  end

  def trip_planner
  end

  def login
  end

  def get_travellers
    # render json: session[:trip].to_json
    render json: create_travellers
  end
end
