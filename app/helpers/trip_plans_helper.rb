require 'csv'

module TripPlansHelper

  DAYS_OF_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]


  # Written by Connor
  # Reads in rows from a .csv file
  # Columns should be in order of Name, Address, isDriver (boolean), Passengers
  # Passengers should be 0 if isDriver == false
  # persons is a 2D array that stores [row#][0-4],
  # where 0 is name, 1 is email, 2 is address, 3 is isDriver, 4 is Passengers
  # Size of persons[] is dynamic based on number of rows in .csv
  # If .csv has a header, add true to head when calling load_csv.
  def get_travellers_from_csv(file, head = false)
    #Check that file name ends with .csv
    #if path[path.to_s.length-4,4].to_s != ".csv"
    # puts "Error: File is not a .csv"
    #else
    persons = Array.new
    i = 0

    CSV.foreach(file.path, col_sep: ',') do |row|
      persons[i] = row
      #Check each element of each row to make sure correct values are entered
      #Check if name has a number in it
      if persons[i][0] == nil
        puts "Error: #{persons[i]} Name is nil"
        raise ArgumentError.new("Empty name in row #{i+1}. Name is a required field.")
      end
      #Check that email is not nil
      #Need to add a check that makes sure email has a @ in it
      if persons[i][1] == nil
        puts "Error: #{persons[i]} Email is nil"
        raise ArgumentError.new("Empty email in row #{i+1}. Email is a required field.")
      elsif /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(persons[i][1]) == nil
        puts "Error: #{persons[i]} Email is invalid"
        raise ArgumentError.new("Invalid email in row #{i+1}. Check for valid email.")
      end
      #Check that address is not nil
      if persons[i][2] == nil
        puts "Error: #{persons[i]} Address is nil"
        raise ArgumentError.new("Empty address in row #{i+1}. Address is a required field.")
      end
      #Check if isDriver has a value other than true or false
      if persons[i][3] != 'TRUE' && persons[i][3] != 'FALSE'
        puts 'Error: isDriver isnt a boolean value'
        raise ArgumentError.new("Error detected with 'isDriver' field in row #{i+1}. 'isDriver' must be true or false.")
      elsif persons[i][2] == nil
        puts "Error: #{persons[i]} isDriver is nil"
        raise ArgumentError.new("Empty 'isDriver' field in row #{i+1}. 'isDriver' must be true or false.")
      end
      #Check if isDriver is false but is allowed to have passengers
      if persons[i][3] == 'FALSE' && persons[i][4] != '0'
        puts 'Error: isDriver is false but has passengers'
        raise ArgumentError.new("Error detected with num_of_passengers field in row #{i+1}. 'isDriver' is false but num_of_passengers does not equal 0.")
      elsif persons[i][4] == nil
        puts "Error: #{persons[i]} Passengers is nil"
        raise ArgumentError.new("Error detected with num_of_passengers field in row #{i+1}. num_of_passengers field must contain a number between 0-7 for drivers.")
      end

      #Check if isDriver is True but error with number of passengers
      if persons[i][3] == 'TRUE' && !(persons[i][4] =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/)
        puts "Error: 'num_of_passengers' field doesn't contain a number"
        raise ArgumentError.new("Error detected with 'num_of_passengers' field in row #{i+1}. Field must contain a number.")
      elsif persons[i][3] == 'TRUE' && persons[i][4].to_i > 7
        puts 'Error: isDriver is true but has too many passengers'
        raise ArgumentError.new("Error detected with 'num_of_passengers' field in row #{i+1}. RideOrganizer does not currently support more than 7 passengers.")
      end
      i += 1
    end

    return persons
  end

  # Processes the csv input and creates the parsed drivers nad passengers.
  def process_trip_travellers(csv_file)

    persons = get_travellers_from_csv(csv_file)

    travellers = []

    persons.each_with_index do |person, i|
      coordinates = GoogleAPIGeocoder.do_geocode(person[2])
      if coordinates.nil?
        raise ArgumentError.new("Unable to find the location of the address in row #{i+1}. Please check that it is correct.")
      end
      latitude = coordinates[0]
      longitude = coordinates[1]
      if person[3] == 'TRUE'
        travellers << Driver.create(name: person[0], email: person[1], address: person[2], number_of_passengers: person[4].to_i, latitude: latitude, longitude: longitude)
      else
        travellers << Passenger.create(name: person[0], email: person[1], address: person[2], latitude: latitude, longitude: longitude)
      end
    end

    return travellers
  end
end
