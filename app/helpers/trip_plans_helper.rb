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
        raise ArgumentError.new("Empty name in row #{i}. Name is a required field.")
      end
      #Check that email is not nil
      #Need to add a check that makes sure email has a @ in it
      if (persons[i][1] == nil)
        puts "Error: #{persons[i]} Email is nil"
        raise ArgumentError.new("Empty email in row #{i}. Email is a required field.")
      elsif (/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(persons[i][1]) == nil)
        puts "Error: #{persons[i]} Email is invalid"
        raise ArgumentError.new("Invalid email in row #{i}. Check for valid email.")
      end
      #Check that address is not nil
      if (persons[i][2] == nil)
        puts "Error: #{persons[i]} Address is nil"
        raise ArgumentError.new("Empty address in row #{i}. Address is a required field.")
      end
      #Check if isDriver has a value other than true or false
      if (persons[i][3] != "TRUE" && persons[i][3] != "FALSE")
        puts "Error: isDriver isnt a boolean value"
        raise ArgumentError.new("Error detected with 'isDriver' field in row #{i}. 'isDriver' must be a Boolean value.")
      elsif (persons[i][2] == nil)
        puts "Error: #{persons[i]} isDriver is nil"
        raise ArgumentError.new("Empty 'isDriver' field in row #{i}. 'isDriver' must contain a Boolean value.")
      end
      #Check if isDriver is false but is allowed to have passengers
      if (persons[i][3] == "FALSE" && persons[i][4] != "0")
        puts "Error: isDriver is false but has passengers"
        raise ArgumentError.new("Error detected with 'num_of_passengers' field in row #{i}. 'isDriver' is false but 'num_of_passengers' does not equal 0.")
      elsif (persons[i][4] == nil)
        puts "Error: #{persons[i]} Passengers is nil"
        raise ArgumentError.new("Error detected with 'num_of_passengers' field in row #{i}. 'num_of_passengers' field must contain a number between 0-7 for drivers.")
      end
      #Check if isDriver is True but error with number of passengers
      if (persons[i][3] == "TRUE" && /[0-7]/.match(persons[i][4].to_i) == nil)
        puts "Error: isDriver is true but has too many passengers"
        raise ArgumentError.new("Error detected with 'num_of_passengers' field in row #{i}. Application does not support more than 7 passengers.")
      elsif (persons[i][3] == "TRUE" && persons[i][4].to_i > 7)
        puts "Error: 'num_of_passengers' field doesn't contain a number"
        raise ArgumentError.new("Error detected with 'num_of_passengers' field in row #{i}. Field must contain a number.")
      end
      i += 1
    end

    #session[:current_persons] = persons
    return persons
    #end
  end

  def process_trip_travellers(csv_file)

    persons = get_travellers_from_csv(csv_file)

    travellers = []

    persons.each() do |person|
      if (person[3] == "TRUE")
        travellers << Driver.create(name: person[0], email: person[1], address: person[2], number_of_passengers: person[4].to_i)
      else
        travellers << Passenger.create(name: person[0], email: person[1], address: person[2])
      end
    end

    return travellers
  end
end
