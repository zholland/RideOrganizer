class TripPlansController < ApplicationController
  DAYS_OF_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def new
  end

  def create
    destination_address = params[:destination_address]

    year = params[:arrival_time][:year]
    month = params[:arrival_time][:month]
    day = params[:arrival_time][:day]
    hour = params[:arrival_time][:hour]
    minute = params[:arrival_time][:minute]
    second = params[:arrival_time][:second]

    # Year
    if (year =~ /^[2][0-9]{3}$/)
      year = year.to_i

      if (year == 2010)
        return redirect_to :action => 'index'
      end
    else
      return redirect_to :action => 'index'
    end

    # Month
    if (month =~ /^([1][0-2]|[1-9])$/)
      month = month.to_i
    else
      return redirect_to :action => 'index'
    end

    # Day
    if (day =~  /^([0]?[1-9]|3[0-1]|[12][0-9]|)$/)
      day = day.to_i

      if (day > DAYS_OF_MONTH[month-1])
        return redirect_to :action => 'index'
      end
    else
      return redirect_to :action => 'index'
    end

    # Hour

    arrival_time = DateTime.civil()

    trip = Trip.new(destination_address, arrival_time)

    trip.add_driver(Driver.new("Denis Vasilyev", "denisvasilyev@email.com", "387 Bernard Avenue, Kelowna, BC", 4))
    trip.add_driver(Driver.new("Bronislava Matveev", "bronislavamatveev@email.com", "1901 Harvey Ave, Kelowna, BC", 2))
    trip.add_driver(Driver.new("Feliks Konstantinov", "felikskonstantinov@email.com", "1000 K. L. O. Rd, Kelowna, BC", 3))
    trip.add_passenger(Passenger.new("Klara Utkin", "klarautkin@email.com", "4346 Gordon Dr, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Rolan Pavlov", "rolanpavlov@email.com", "705 Kitch Rd, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Geert Alvarsson", "geertalvarsson@email.com", "820 Guy St, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Anina Madsen", "aninamadsen@email.com", "715 Rutland Road North, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Gennadiz Hivkov", "gennadizhivkov@email.com", "1938 Kane Rd, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Mitrofan Pavlov", "mitrofanpavlov@email.com", "5533 Airport Way, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Anna Sokolov", "annasokolov@email.com", "1959 K. L. O. Road, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Milena Volkov", "milenavolkov@email.com", "190 Aurora Crescent, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Manya Yakovlev", "manyayakovlev@email.com", "1505 Gordon Dr, Kelowna, BC"))
    trip.add_passenger(Passenger.new("Feodora Petrov", "feodorapetrov@email.com", "1555 Burtch Road, Kelowna, BC"))

    traveller_matching = TravellerMatching.new(trip)
    trip = traveller_matching.group_travellers.to_json

    session[:trip] = nil
    session[:trip] = trip

    redirect_to trip_plans_planner_output_path
  end

  def get_travellers
    trip = session[:trip]
    session[:trip] = nil

    render json: trip
  end

  def planner_output
  end
end
