# Controller for all trip creation and optimization.
class TripPlansController < ApplicationController
  include TripPlansHelper

  # Render the default view.
  def index
    if current_user != nil
      redirect_to trip_plans_choose_path
    end
  end

  # Choose trips page.
  def choose
    if current_user != nil
      @trips = Trip.where('user_id = ?', current_user.id)
    end
  end

  # New trips page.
  def new
    # Run traveller table cleanup
    puts Time.now
    puts Time.now - 48.hours
    travellers = Traveller.joins('LEFT OUTER JOIN travellers_trips ON travellers.id = travellers_trips.traveller_id')
                     .where('travellers_trips.traveller_id is NULL AND travellers.created_at < ?', Time.now - 48.hours)

    travellers.each do |t|
      t.destroy
    end

    # New trip logic
    @trip = Trip.new

    # Clear session of trip and travellers
    session[:trip] = nil
    session[:travellers] = nil

    # If a file is uploaded, process it.
    if remotipart_submitted?
      begin
        unless session[:travellers].nil?
          session[:travellers] << process_trip_travellers(params[:trip][:traveller_csv])
        else
          session[:travellers] = process_trip_travellers(params[:trip][:traveller_csv])
        end
      rescue ArgumentError => e
        @error_msg = e.message
      end
    else
      session[:travellers] = nil
    end
  end

  # Controller target to create a new driver. Has no associated view.
  def new_driver
    address = params[:newdriveraddress]

    coordinates = GoogleAPIGeocoder.do_geocode(address)

    if coordinates.nil?
      render json: {success: false, travellers: session[:travellers].to_json, msg: 'Unable to find the location of the given address for the new driver. Please check that it is correct.'}
    else
      driver = Driver.create(name: params[:newdrivername],
                             email: params[:newdriveremail],
                             address: address,
                             number_of_passengers: params[:newdrivernumber_of_passengers],
                             latitude: coordinates[0],
                             longitude: coordinates[1])

      unless session[:travellers].nil?
        session[:travellers] << driver
      else
        travellers = []
        travellers << driver
        session[:travellers] = travellers
      end

      if current_user.nil? && !session[:trip].nil?
        session[:trip].travellers << driver
      end

      render json: session[:travellers].to_json
    end
  end

  # Controller target to create a new passenger. Has no associated view.
  def new_passenger
    address = params[:newpassengeraddress]

    coordinates = GoogleAPIGeocoder.do_geocode(address)

    if coordinates.nil?
      render json: {success: false, travellers: session[:travellers].to_json, msg: 'Unable to find the location of the given address for the new driver. Please check that it is correct.'}
    else
      passenger = Passenger.create(name: params[:newpassengername],
                                   email: params[:newpassengeremail],
                                   address: address,
                                   latitude: coordinates[0],
                                   longitude: coordinates[1])

      unless session[:travellers].nil?
        session[:travellers] << passenger
      else
        travellers = []
        travellers << passenger
        session[:travellers] = travellers
      end

      if current_user.nil? && !session[:trip].nil?
        session[:trip].travellers << passenger
      end

      render json: session[:travellers].to_json
    end
  end

  # Edit trips page.
  def edit
    if current_user != nil
      @trip = Trip.find(params[:id])

      # When a file is uploaded, process it.
      if remotipart_submitted?
        begin
          travellers = process_trip_travellers(params[:trip][:traveller_csv])
          travellers.each do |t|
            @trip.travellers << t
          end
        rescue ArgumentError => e
          @error_msg = e.message
        end
      end

      session[:travellers] = @trip.travellers
    else
      redirect_to trip_plans_guest_edit_path
    end
  end

  # Special edit page for guest that are not logged in.
  def guest_edit
    # If the use IS logged in, redirect them to the home page. The guest edit is only for users not logged in.
    if current_user == nil && session[:trip] != nil
      @trip = session[:trip]

      if remotipart_submitted?
        begin
          travellers = process_trip_travellers(params[:trip][:traveller_csv])
          travellers.each do |t|
            @trip.travellers << t
          end
        rescue ArgumentError => e
          @error_msg = e.message
        end
      end

      session[:trip] = @trip
    else
      redirect_to pages_home_path
    end
  end

  # Creates a new trip.
  def create
    @trip = Trip.new(trip_params)

    # Retrieve the trip travellers from the session.
    travellers = session[:travellers]
    if travellers != nil
      travellers.each do |t|
        @trip.travellers << t
      end
    end

    destination_coordinates = GoogleAPIGeocoder.do_geocode(@trip.destination_address)

    if destination_coordinates.nil?
      @trip.delete
      redirect_to trip_plan_path, :alert => 'Invalid destination'
    end

    # Update the trip destination coordinates.
    @trip.update(destination_latitude: destination_coordinates[0])
    @trip.update(destination_longitude: destination_coordinates[1])


    if current_user != nil
      @trip.user_id = current_user.id
      @trip.save
      redirect_to edit_trip_plan_path(@trip)
    else
      session[:trip] = @trip
      redirect_to trip_plans_guest_edit_path
    end
  end

  # Updates the trip for logged in users.
  def update
    if current_user != nil
      @trip = Trip.find(params[:id])
      @trip.update(trip_params)
      redirect_to edit_trip_plan_path(@trip)
    else
      redirect_to new_user_session_path
    end
  end

  # Updates the trip for guest users (not logged in)
  def guest_update
    @trip = session[:trip]
    if @trip != nil
      @trip.update(trip_params)
      redirect_to trip_plans_guest_edit_path
    else
      redirect_to trip_plans_choose_path
    end
  end

  # Deletes a trip
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    redirect_to trip_plans_choose_path
  end

  # Deletes a traveller
  def destroy_traveller
    @traveller = Traveller.find(params[:traveller_id])

    if session[:travellers] != nil && session[:travellers].include?(@traveller)
      session[:travellers].delete(@traveller)
    end

    if current_user.nil? && session[:trip] != nil
      session[:trip].travellers.delete(@traveller)
    end

    @traveller.destroy

    render json: {message: 'success'}
  end

  # Retrieves all the trip travellers as a json string.
  def get_travellers
    if current_user != nil
      @trip = Trip.find(params[:id])
      render json: @trip.trip_json
    else
      render json: session[:trip].trip_json
    end

  end

  # Target for the trip planner output page.
  def planner_output
    if current_user != nil
      @trip = Trip.find(params[:id])
    else
      redirect_to new_user_session_path
    end

    @trip.routes.each { |r| r.destroy }

    traveller_matching = TravellerMatching.new(@trip.to_object_container_no_routes)
    @trip.create_routes_from_trip_object(traveller_matching.trip)

    trip_json = traveller_matching.trip.to_json


    @trip.trip_json = trip_json
    @trip.save
  end

  # Target for the guest trip planner output page. For users that are not logged in.
  def guest_planner_output
    @trip = session[:trip]

    traveller_matching = TravellerMatching.new(@trip.to_object_container_no_routes)
    trip_json = traveller_matching.trip.to_json

    @trip.trip_json = trip_json

    session[:trip] = @trip
  end

  # Post target for editing the name of a traveller.
  def edit_name
    traveller = Traveller.find(params[:pk])
    traveller.update(name: params[:value])

    if current_user.nil?
      if session[:trip] != nil
        travellers = session[:trip].travellers
        travellers[travellers.index(traveller)].name = params[:value]
      end

      if session[:travellers] != nil
        session[:travellers][session[:travellers].index(traveller)].name = params[:value]
      end
    end

    render json: {success: 'name updated successfully'}
  end

  # Post target for editing the email of a traveller.
  def edit_email
    traveller = Traveller.find(params[:pk])
    traveller.update(email: params[:value])

    if current_user.nil?
      if session[:trip] != nil
        travellers = session[:trip].travellers
        travellers[travellers.index(traveller)].email = params[:value]
      end

      if session[:travellers] != nil
        session[:travellers][session[:travellers].index(traveller)].email = params[:value]
      end
    end

    render json: {success: 'email updated successfully'}
  end

  # Post target for editing the address of a traveller.
  def edit_address
    traveller = Traveller.find(params[:pk])
    address = params[:value]

    coordinates = GoogleAPIGeocoder.do_geocode(address)

    if coordinates.nil?
      render json: {success: false, msg: 'Unable to find the location of the given address. Please check that it is correct.'}
    else
      traveller.update(address: address, latitude: coordinates[0], longitude: coordinates[1])

      if current_user.nil?
        if session[:trip] != nil
          travellers = session[:trip].travellers
          travellers[travellers.index(traveller)].address = params[:value]
        end

        if session[:travellers] != nil
          session[:travellers][session[:travellers].index(traveller)].address = params[:value]
        end
      end

      render json: {success: true}
    end
  end

  # Post target for editing the capacity of a driver's car.
  def edit_number_of_passengers
    traveller = Traveller.find(params[:pk])
    traveller.update(number_of_passengers: params[:value])

    if current_user.nil?
      if session[:trip] != nil
        travellers = session[:trip].travellers
        travellers[travellers.index(traveller)].number_of_passengers = params[:value]
      end

      if session[:travellers] != nil
        session[:travellers][session[:travellers].index(traveller)].number_of_passengers = params[:value]
      end
    end

    render json: {success: 'number of passengers updated successfully'}
  end

  # Initiates sending emails to all the trip's drivers and passengers.
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

    render json: {message: 'Emails were successfully sent.'}
  end


  # Validate the trip destination address
  def validate_address
    trip_address = params[:data]
    coordinate_array = nil

    # Call to the geocoder API returns nil if the address cannot be geocoded
    coordinate_array = GoogleAPIGeocoder.do_geocode(trip_address)

    if coordinate_array.nil?
      render json: {response: "-1"}
    else
      render json: {response: "1"}
    end

  end

  private
  def trip_params
    params.require(:trip).permit(:destination_address, :arrival_time)
  end
end
