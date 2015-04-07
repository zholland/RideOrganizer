require 'test/unit'
require_relative '../../app/classes/google_api_geocoder'
require_relative '../../app/classes/trip_container'
require_relative '../../app/classes/driver_container'
require_relative '../../app/classes/passenger_container'

class GoogleAPIGeocoderTest < Test::Unit::TestCase
  def setup
    @trip = TripContainer.new("3333 University Way, Kelowna, BC", Time.now)
    @trip.add_driver(DriverContainer.new(1, "Denis Vasilyev", "denisvasilyev@email.com", "387 Bernard Avenue, Kelowna, BC", 4))
    @trip.add_driver(DriverContainer.new(1, "Denis Vasilyev", "denisvasilyev@email.com", "FAKE ADDRESS jdij23d09239d93d", 4))
  end

  def teardown
    @trip = nil
  end

  def test_geocoder
    coordinates = []
    coordinates << GoogleAPIGeocoder.do_geocode(@trip.destination_address)

    @trip.drivers.each do |driver|
      coordinates << GoogleAPIGeocoder.do_geocode(driver.address)
    end

    assert_equal(3, coordinates.size)
    assert_equal([49.9400389, -119.3952381], coordinates[0])
    assert_equal([49.8863041, -119.4951311], coordinates[1])
    assert_equal(nil, coordinates[2])
  end
end