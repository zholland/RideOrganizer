require 'uri'

# Mailer for the driver emails
class DriverMailer < ApplicationMailer
  def trip_email(trip, driver, trip_output_data, user)
    @driver = driver
    @trip = trip
    @trip_output_data = trip_output_data
    @route = @trip.routes.select { |r| r.driver == @driver }.first
    @user = user
    traveller_data = trip_output_data[@route.id.to_s]
    @travellers = sort_travellers(traveller_data)
    @map_url = build_maps_url(@travellers)
    mail(to: @driver.email, subject: "RideOrganizer: Trip to #{@trip.destination_address}")
  end

  # Sorts the passengers to their respective drivers.
  private
  def sort_travellers(traveller_data)
    sorted_travellers = Array.new(traveller_data.size)
    traveller_data.each { |id, data| sorted_travellers[data['0']['pickupPos'].to_i - 1] = Traveller.find(id) }
    return sorted_travellers
  end

  # Creates the map link url for the email.
  private
  def build_maps_url(travellers)
    url = "http://maps.google.com/maps?saddr=#{escape(@driver.address)}&daddr=#{escape(travellers[0].address)}"
    for i in 1..travellers.length - 1
      url += "+to:#{escape(travellers[i].address)}"
    end
    url += "+to:#{escape(@trip.destination_address)}"
    return url
  end

  # Escapes the given text to make it safe for a URL.
  private
  def escape(text)
    URI.escape(text)
  end
end
