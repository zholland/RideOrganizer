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
    # Run traveller table cleanup
    puts Time.now
    puts Time.now - 48.hours
    travellers = Traveller.joins('LEFT OUTER JOIN travellers_trips ON travellers.id = travellers_trips.traveller_id')
                     .where('travellers_trips.traveller_id is NULL AND travellers.created_at < ?', Time.now - 48.hours)

    travellers.each do |t|
      t.destroy
    end


    # records_array = ActiveRecord::Base.connection.execute(sql)

    # New trip logic
    @trip = Trip.new

    if remotipart_submitted?
      unless session[:travellers].nil?
        session[:travellers] < process_trip_travellers(params[:trip][:traveller_csv])
      else
        session[:travellers] = process_trip_travellers(params[:trip][:traveller_csv])
      end
    else
      session[:travellers] = nil
    end
  end

  def new_driver
    driver = Driver.create(name: params[:newdrivername],
                           email: params[:newdriveremail],
                           address: params[:newdriveraddress],
                           number_of_passengers: params[:newdrivernumber_of_passengers])

    unless session[:travellers].nil?()
      session[:travellers] << driver
    else
      travellers = []
      travellers << driver
      session[:travellers] = travellers
    end

    if current_user.nil?
      session[:trip].travellers << driver
    end

    render json: session[:travellers].to_json
  end

  def new_passenger
    passenger = Passenger.create(name: params[:newpassengername],
                                 email: params[:newpassengeremail],
                                 address: params[:newpassengeraddress])

    unless session[:travellers].nil?()
      session[:travellers] << passenger
    else
      travellers = []
      travellers << passenger
      session[:travellers] = travellers
    end

    if current_user.nil?
      session[:trip].travellers << passenger
    end

    render json: session[:travellers].to_json
  end

  def edit
    if current_user != nil
      @trip = Trip.find(params[:id])

      if remotipart_submitted?
        travellers = process_trip_travellers(params[:trip][:traveller_csv])
        travellers.each do |t|
          @trip.travellers << t
        end
      end

      session[:travellers] = @trip.travellers
    else
      redirect_to trip_plans_guest_edit_path
    end
  end

  def guest_edit
    if current_user == nil && session[:trip] != nil
      @trip = session[:trip]

      if remotipart_submitted?
        travellers = process_trip_travellers(params[:trip][:traveller_csv])
        travellers.each do |t|
          @trip.travellers << t
        end
      end

      session[:trip] = @trip
    else
      redirect_to pages_home_path
    end
  end

  def create
    @trip = Trip.new(trip_params)

    travellers = session[:travellers]
    if travellers != nil
      travellers.each do |t|
        @trip.travellers << t
      end
    end

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

  def destroy_traveller
    @traveller = Traveller.find(params[:traveller_id])

    if session[:travellers] != nil && session[:travellers].include?(@traveller)
      session[:travellers].delete(@traveller)
    end

    if current_user.nil?
      session[:trip].travellers.delete(@traveller)
    end

    @traveller.destroy

    render json: {message: 'success'}
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

    @trip.routes.each { |r| r.destroy }

    traveller_matching = TravellerMatching.new(@trip.to_object_container_no_routes)
    trip_json = traveller_matching.trip.to_json

    @trip.create_routes_from_trip_object(traveller_matching.trip)

    @trip.trip_json = trip_json
    @trip.save
  end

  def guest_planner_output
    @trip = session[:trip]

    traveller_matching = TravellerMatching.new(@trip.to_object_container_no_routes)
    trip_json = traveller_matching.trip.to_json

    @trip.trip_json = trip_json

    session[:trip] = @trip
  end

  def edit_name
    traveller = Traveller.find(params[:pk])
    traveller.update(name: params[:value])

    if current_user.nil?
      travellers = session[:trip].travellers
      travellers[travellers.index(traveller)].name = params[:value]
    end

    render json: {success: 'name updated successfully'}
  end

  def edit_email
    traveller = Traveller.find(params[:pk])
    traveller.update(email: params[:value])

    if current_user.nil?
      travellers = session[:trip].travellers
      travellers[travellers.index(traveller)].email = params[:value]
    end

    render json: {success: 'email updated successfully'}
  end

  def edit_address
    traveller = Traveller.find(params[:pk])
    traveller.update(address: params[:value])

    if current_user.nil?
      travellers = session[:trip].travellers
      travellers[travellers.index(traveller)].address = params[:value]
    end

    render json: {success: 'address updated successfully'}
  end

  def edit_number_of_passengers
    traveller = Traveller.find(params[:pk])
    traveller.update(number_of_passengers: params[:value])

    if current_user.nil?
      travellers = session[:trip].travellers
      travellers[travellers.index(traveller)].number_of_passengers = params[:value]
    end

    render json: {success: 'number of passengers updated successfully'}
  end

  def notify_travellers
    if current_user.nil?
      trip = session[:trip]
    else
      trip = Trip.find(params[:id])
    end

    drivers = []
    passengers = []

    trip.travellers.each do |t|
      if t.type == 'Driver'
        drivers << t
      else
        passengers << t
      end
    end

    trip_output_data = params[:data]

    drivers.each { |driver| DriverMailer.trip_email(trip, driver, trip_output_data, current_user).deliver_now }
    passengers.each { |passenger| PassengerMailer.trip_email(trip, passenger, trip_output_data, current_user).deliver_now }

    render json: { message: 'success'}
  end

  private
  def trip_params
    params.require(:trip).permit(:destination_address, :arrival_time)
  end
end
