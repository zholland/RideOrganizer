require 'test/unit'
require_relative '../../app/classes/traveller_matching'
require_relative '../../app/classes/trip'
require_relative '../../app/classes/driver'
require_relative '../../app/classes/passenger'

class TravellerMatchingTest < Test::Unit::TestCase
  def setup
    trip = Trip.new("3333 University Way, Kelowna, BC", Time.now)
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

    @traveller_matching = TravellerMatching.new(trip)
  end

  def teardown
    @traveller_matching = nil
  end

  def test_group_travellers
    trip = @traveller_matching.group_travellers
    route_outputs = Array.new

    route_outputs << Array.new
    route_outputs[0] << Array.new
    route_outputs[0][0] << "Name: Denis Vasilyev, Email: denisvasilyev@email.com, Address: 387 Bernard Avenue, Kelowna, BC, NumberOfPassengers: 4"
    route_outputs[0] << Array.new
    route_outputs[0][1] << "Name: Gennadiz Hivkov, Email: gennadizhivkov@email.com, Address: 1938 Kane Rd, Kelowna, BC"
    route_outputs[0][1] << "Name: Geert Alvarsson, Email: geertalvarsson@email.com, Address: 820 Guy St, Kelowna, BC"
    route_outputs[0][1] << "Name: Anina Madsen, Email: aninamadsen@email.com, Address: 715 Rutland Road North, Kelowna, BC"
    route_outputs[0][1] << "Name: Rolan Pavlov, Email: rolanpavlov@email.com, Address: 705 Kitch Rd, Kelowna, BC"

    route_outputs << Array.new
    route_outputs[1] << Array.new
    route_outputs[1][0] << "Name: Bronislava Matveev, Email: bronislavamatveev@email.com, Address: 1901 Harvey Ave, Kelowna, BC, NumberOfPassengers: 2"
    route_outputs[1] << Array.new
    route_outputs[1][1] << "Name: Feodora Petrov, Email: feodorapetrov@email.com, Address: 1555 Burtch Road, Kelowna, BC"
    route_outputs[1][1] << "Name: Milena Volkov, Email: milenavolkov@email.com, Address: 190 Aurora Crescent, Kelowna, BC"

    route_outputs << Array.new
    route_outputs[2] << Array.new
    route_outputs[2][0] << "Name: Feliks Konstantinov, Email: felikskonstantinov@email.com, Address: 1000 K. L. O. Rd, Kelowna, BC, NumberOfPassengers: 3"
    route_outputs[2] << Array.new
    route_outputs[2][1] << "Name: Manya Yakovlev, Email: manyayakovlev@email.com, Address: 1505 Gordon Dr, Kelowna, BC"
    route_outputs[2][1] << "Name: Mitrofan Pavlov, Email: mitrofanpavlov@email.com, Address: 5533 Airport Way, Kelowna, BC"
    route_outputs[2][1] << "Name: Klara Utkin, Email: klarautkin@email.com, Address: 4346 Gordon Dr, Kelowna, BC"

    trip.routes.each_with_index do |route, r_index|
      assert_equal(route_outputs[r_index][0][0], route.driver.to_s)
      route.passengers.each_with_index do |passenger, p_index|
        assert_equal(route_outputs[r_index][1][p_index], passenger.to_s)
      end
    end
  end
end