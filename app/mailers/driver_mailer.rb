class DriverMailer < ApplicationMailer
 def trip_email(trip, driver, trip_output_data)
   @driver = driver
   @trip = trip
   @trip_output_data = trip_output_data
   mail(to: @driver.email, subject: "RideOrganizer: Trip to #{@trip.destination_address}")
 end
end
