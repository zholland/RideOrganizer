=begin
Written by Connor
Reads in rows from a .csv file
Columns should be in order of Name, Address, isDriver (boolean), Passengers
Passengers should be 0 if isDriver == false
persons is a 2D array that stores [row#][0-4], 
where 0 is name, 1 is email, 2 is address, 3 is isDriver, 4 is Passengers
Size of persons[] is dynamic based on number of rows in .csv
If .csv has a header, add true to head when calling load_csv.
=end

require 'csv'

def load_csv(path, head = false)
  #Check that file name ends with .csv
  #if path[path.to_s.length-4,4].to_s != ".csv"
   # puts "Error: File is not a .csv"
  #else
    persons = Array.new
    i = 0

    CSV.foreach(path.to_s,  col_sep: ',') do |row|
      persons[i] = row
      #Check each element of each row to make sure correct values are entered
      #Check if name has a number in it
      if /\d/.match(persons[i][0])
        puts "Error: Name has Int value"
      elsif persons[i][0] == nil
        puts "Error: #{persons[i]} Name is nil"
      end
      #Check that email is not nil
      #Need to add a check that makes sure email has a @ in it
      if(persons[i][1] == nil)
        puts "Error: #{persons[i]} Email is nil"
      end
      #Check that address is not nil
      if (persons[i][2] == nil)
        puts "Error: #{persons[i]} Address is nil"
      end
      #Check if isDriver has a value other than true or false
      if (persons[i][3] != "TRUE" && persons[i][3] != "FALSE")
        puts "Error: isDriver isnt a bool value"
      elsif (persons[i][2] == nil)
        puts "Error: #{persons[i]} isDriver is nil"
      end
      #Check if isDriver is false but is allowed to have passengers
      if (persons[i][3] == "FALSE" && persons[i][4] != "0")
        puts "Error: isDriver is false but has passengers"
      elsif (persons[i][4] == nil)
        puts "Error: #{persons[i]} Passengers is nil"
      end
      i += 1
    end

    #session[:current_persons] = persons
    return persons
  #end
end

## For Testing:
# puts load_csv('inputtest.csv').to_s