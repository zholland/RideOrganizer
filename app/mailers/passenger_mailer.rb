# Mailer for the passenger emails.
class PassengerMailer < ApplicationMailer
  def trip_email(trip, passenger, trip_output_data, user)
    @passenger = passenger
    @trip = trip
    @trip_output_data = trip_output_data
    @route = @trip.routes.select { |r| r.travellers.include?(@passenger) }.first
    @pickup_time = trip_output_data[@route.id.to_s][@passenger.id.to_s]['0']['pickupTime']
    @user = user
    mail(to: @passenger.email, subject: "RideOrganizer: Trip to #{@trip.destination_address}")
  end
end
