require 'test/unit'
require_relative '../../app/classes/traveller_matching'
require_relative '../../app/classes/trip_container'
require_relative '../../app/classes/driver_container'
require_relative '../../app/classes/passenger_container'
require_relative '../../app/classes/route_container'

class TravellerMatchingTest < Test::Unit::TestCase
  def setup
    trip = TripContainer.new('3333 University Way, Kelowna, BC', Time.now)
    trip.destination_latitude = 49.94003
    trip.destination_longitude = -119.39273

    d1 = DriverContainer.new(1, 'Denis Vasilyev', 'denisvasilyev@email.com', '387 Bernard Avenue, Kelowna, BC', 4)
    d1.latitude = 49.8863041
    d1.longitude = -119.4951311
    trip.add_driver(d1)

    d2 = DriverContainer.new(1, 'Bronislava Matveev', 'bronislavamatveev@email.com', '1901 Harvey Ave, Kelowna, BC', 2)
    d2.latitude = 49.8818695
    d2.longitude = -119.4544698
    trip.add_driver(d2)

    d3 = DriverContainer.new(1, 'Feliks Konstantinov', 'felikskonstantinov@email.com', '1000 K. L. O. Rd, Kelowna, BC', 4)
    d3.latitude = 49.86162849999999
    d3.longitude = -119.4792715
    trip.add_driver(d3)

    p1 = PassengerContainer.new(1, 'Klara Utkin', 'klarautkin@email.com', '4346 Gordon Dr, Kelowna, BC')
    p1.latitude = 49.8278748
    p1.longitude = -119.4832848
    trip.add_passenger(p1)

    p2 = PassengerContainer.new(1, 'Rolan Pavlov', 'rolanpavlov@email.com', '705 Kitch Rd, Kelowna, BC')
    p2.latitude = 49.8807206
    p2.longitude = -119.4001888
    trip.add_passenger(p2)

    p3 = PassengerContainer.new(1, 'Geert Alvarsson', 'geertalvarsson@email.com', '820 Guy St, Kelowna, BC')
    p3.latitude = 49.8998564
    p3.longitude = -119.5000729
    trip.add_passenger(p3)

    p4 = PassengerContainer.new(1, 'Anina Madsen', 'aninamadsen@email.com', '715 Rutland Road North, Kelowna, BC')
    p4.latitude = 49.8979059
    p4.longitude = -119.3862294
    trip.add_passenger(p4)

    p5 = PassengerContainer.new(1, 'Gennadiz Hivkov', 'gennadizhivkov@email.com', '1938 Kane Rd, Kelowna, BC')
    p5.latitude = 49.91574749999999
    p5.longitude = -119.4437679
    trip.add_passenger(p5)

    p6 = PassengerContainer.new(1, 'Mitrofan Pavlov', 'mitrofanpavlov@email.com', '5533 Airport Way, Kelowna, BC')
    p6.latitude = 49.9510197
    p6.longitude = -119.3815103
    trip.add_passenger(p6)

    p7 = PassengerContainer.new(1, 'Anna Sokolov', 'annasokolov@email.com', '1959 K. L. O. Road, Kelowna, BC')
    p7.latitude = 49.8609348
    p7.longitude = -119.4559874
    trip.add_passenger(p7)

    p8 = PassengerContainer.new(1, 'Milena Volkov', 'milenavolkov@email.com', '190 Aurora Crescent, Kelowna, BC')
    p8.latitude = 49.88998729999999
    p8.longitude = -119.3958887
    trip.add_passenger(p8)

    p9 = PassengerContainer.new(1, 'Manya Yakovlev', 'manyayakovlev@email.com', '1505 Gordon Dr, Kelowna, BC')
    p9.latitude = 49.8860284
    p9.longitude = -119.4767659
    trip.add_passenger(p9)

    p10 = PassengerContainer.new(1, 'Feodora Petrov', 'feodorapetrov@email.com', '1555 Burtch Road, Kelowna, BC')
    p10.latitude = 49.88444639999999
    p10.longitude = -119.4623452
    trip.add_passenger(p10)

    trip.add_to_whitelist(d1, p10)

    @traveller_matching = TravellerMatching.new(trip)
  end

  def teardown
    @traveller_matching = nil
  end

  def test_group_travellers
    trip = @traveller_matching.trip
    puts trip.to_s
    route_outputs = Array.new

    route_outputs << Array.new
    route_outputs[0] << Array.new
    route_outputs[0][0] << 'ID: 1, Name: Denis Vasilyev, Email: denisvasilyev@email.com, Address: 387 Bernard Avenue, Kelowna, BC, Latitude: 49.8863041, Longitude: -119.4951311, NumberOfPassengers: 4'
    route_outputs[0] << Array.new
    route_outputs[0][1] << 'ID: 1, Name: Geert Alvarsson, Email: geertalvarsson@email.com, Address: 820 Guy St, Kelowna, BC, Latitude: 49.8998564, Longitude: -119.5000729'
    route_outputs[0][1] << 'ID: 1, Name: Mitrofan Pavlov, Email: mitrofanpavlov@email.com, Address: 5533 Airport Way, Kelowna, BC, Latitude: 49.9510197, Longitude: -119.3815103'
    route_outputs[0][1] << 'ID: 1, Name: Manya Yakovlev, Email: manyayakovlev@email.com, Address: 1505 Gordon Dr, Kelowna, BC, Latitude: 49.8860284, Longitude: -119.4767659'
    route_outputs[0][1] << 'ID: 1, Name: Feodora Petrov, Email: feodorapetrov@email.com, Address: 1555 Burtch Road, Kelowna, BC, Latitude: 49.88444639999999, Longitude: -119.4623452'

    route_outputs << Array.new
    route_outputs[1] << Array.new
    route_outputs[1][0] << 'ID: 1, Name: Bronislava Matveev, Email: bronislavamatveev@email.com, Address: 1901 Harvey Ave, Kelowna, BC, Latitude: 49.8818695, Longitude: -119.4544698, NumberOfPassengers: 2'
    route_outputs[1] << Array.new
    route_outputs[1][1] << 'ID: 1, Name: Milena Volkov, Email: milenavolkov@email.com, Address: 190 Aurora Crescent, Kelowna, BC, Latitude: 49.88998729999999, Longitude: -119.3958887'
    route_outputs[1][1] << 'ID: 1, Name: Gennadiz Hivkov, Email: gennadizhivkov@email.com, Address: 1938 Kane Rd, Kelowna, BC, Latitude: 49.91574749999999, Longitude: -119.4437679'

    route_outputs << Array.new
    route_outputs[2] << Array.new
    route_outputs[2][0] << 'ID: 1, Name: Feliks Konstantinov, Email: felikskonstantinov@email.com, Address: 1000 K. L. O. Rd, Kelowna, BC, Latitude: 49.86162849999999, Longitude: -119.4792715, NumberOfPassengers: 4'
    route_outputs[2] << Array.new
    route_outputs[2][1] << 'ID: 1, Name: Klara Utkin, Email: klarautkin@email.com, Address: 4346 Gordon Dr, Kelowna, BC, Latitude: 49.8278748, Longitude: -119.4832848'
    route_outputs[2][1] << 'ID: 1, Name: Rolan Pavlov, Email: rolanpavlov@email.com, Address: 705 Kitch Rd, Kelowna, BC, Latitude: 49.8807206, Longitude: -119.4001888'
    route_outputs[2][1] << 'ID: 1, Name: Anina Madsen, Email: aninamadsen@email.com, Address: 715 Rutland Road North, Kelowna, BC, Latitude: 49.8979059, Longitude: -119.3862294'
    route_outputs[2][1] << 'ID: 1, Name: Anna Sokolov, Email: annasokolov@email.com, Address: 1959 K. L. O. Road, Kelowna, BC, Latitude: 49.8609348, Longitude: -119.4559874'


    trip.routes.each_with_index do |route, r_index|
      assert_equal(route_outputs[r_index][0][0], route.driver.to_s)
      route.passengers.each_with_index do |passenger, p_index|
        assert_equal(route_outputs[r_index][1][p_index], passenger.to_s)
      end
    end
  end
end