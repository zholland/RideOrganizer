require 'uri'

class DriverMailer < ApplicationMailer
  def trip_email(trip, driver, trip_output_data, user)
    @driver = driver
    @trip = trip
    @trip_output_data = trip_output_data
    @route = @trip.routes.select { |r| r.driver == @driver }.first
    @user = user
    @map_url = build_maps_url
    mail(to: @driver.email, subject: "RideOrganizer: Trip to #{@trip.destination_address}")
  end

  private
  def build_maps_url
    travellers = @route.travellers
    url = "http://maps.google.com/maps?saddr=#{escape(@driver.address)}&daddr=#{escape(travellers[0].address)}"
    for i in 1..travellers.length - 1
      url += "+to:#{escape(travellers[i].address)}"
    end
    url += "+to:#{escape(@trip.destination_address)}"
    return url
  end

  private
  def escape(text)
    URI.escape(text)
  end
end
