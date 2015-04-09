require 'net/http'
require 'json'

class GoogleAPIGeocoder
  API_KEY = 'AIzaSyC6qUy4aKjMOkd8ffdu6rBa44TuhfR3hOA'
  HOST_URL = 'https://maps.googleapis.com/maps/api/geocode/json?key=' + API_KEY + '&address='

  def self.do_geocode(address)
    url = URI.parse(URI.encode((HOST_URL + address).strip))
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => true) {|http|
      http.request(req)
    }
    data = JSON.parse(res.body)

    if data['status'] != 'OK'
      nil
    else
      [data['results'][0]['geometry']['location']['lat'], data['results'][0]['geometry']['location']['lng']]
    end
  end
end