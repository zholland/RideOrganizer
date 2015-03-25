class PassengerMailer < ApplicationMailer
  def trip_email(trip, passenger, trip_output_data)
    @passenger = passenger
    @trip = trip
    @trip_output_data = trip_output_data
    mail(to: @passenger.email, subject: "RideOrganizer: Trip to #{@trip.destination_address}")
  end
end
