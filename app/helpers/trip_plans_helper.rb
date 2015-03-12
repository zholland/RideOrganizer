module TripPlansHelper
  DAYS_OF_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def process_trip_input
    csv_file = params[:traveller_csv]
    # csv_file = "inputtest.csv"

    destination_address = params[:destination_address] # TODO: Need to verify by geocoding

    year = params[:arrival_time][:year]
    month = params[:arrival_time][:month]
    day = params[:arrival_time][:day]
    hour = params[:arrival_time][:hour]
    minute = params[:arrival_time][:minute]

    # Year
    if year =~ /^[2][0-9]{3}$/
      year = year.to_i

      if year == 2010
        return redirect_to :action => 'index'
      end
    else
      return redirect_to :action => 'index'
    end

    # Month
    if month =~ /^([1][0-2]|[1-9])$/
      month = month.to_i
    else
      return redirect_to :action => 'index'
    end

    # Day
    if day =~ /^([0]?[1-9]|3[0-1]|[12][0-9])$/
      day = day.to_i

      if day > DAYS_OF_MONTH[month - 1]
        if year % 4 != 0 || (year % 100 == 0 && year % 400 != 0) || day != 29 || month != 2
          return redirect_to :action => 'index'
        end
      end
    else
      return redirect_to :action => 'index'
    end

    # Hour
    if hour =~ /^([0]?[0-9]|2[0-3]|[1][0-9])$/
      hour = hour.to_i
    else
      return redirect_to :action => 'index'
    end

    # Minutes
    if minute =~ /^([0]?[0-9]|[1-5][0-9])$/
      minute = minute.to_i
    end

    arrival_time = DateTime.civil(year, month, day, hour, minute)

    trip = Trip.new(destination_address, arrival_time)

    persons = load_csv(csv_file.path)

    persons.each() do |person|
      if (person[3] == "TRUE")
        trip.add_driver(Driver.new(person[0], person[1], person[2], person[4].to_i))
      else
        trip.add_passenger(Passenger.new(person[0], person[1], person[2]))
      end
    end

    traveller_matching = TravellerMatching.new(trip)
    trip = traveller_matching.group_travellers.to_json

    session[:trip] = nil
    session[:trip] = trip

    redirect_to trip_plans_planner_output_path
  end
end
