require 'rest_client'

class GoogleAPIGeocoder
  API_KEY = 'AIzaSyC6qUy4aKjMOkd8ffdu6rBa44TuhfR3hOA'
  HOST_URL = 'https://maps.googleapis.com/maps/api/geocode/json?key=' + API_KEY + '&address='
  BATCH_SIZE = 5

  def self.do_geocode(address)
    response = RestClient.get(HOST_URL + address)
    data = JSON.parse(response)

    if data["status"] != "OK"
      nil
    else
      [data["results"][0]["geometry"]["location"]["lat"], data["results"][0]["geometry"]["location"]["lng"]]
    end
  end
end