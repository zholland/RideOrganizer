module PagesHelper

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def createTravellers

    t1 = Trip.new('Vernon, BC', '2015-03-29')

    p1 = Passenger.new('Joe', 'joe@gmail.com', '166 Summerhill Place, Kelowna, BC')
    p2 = Passenger.new('John', 'john@gmail.com', '3333 University Way, Kelowna, BC')
    p3 = Passenger.new('Mark', 'mark@gmail.com', '1 Ellis Street, Kelowna, BC')
    d1 = Driver.new('Luke', 'luke@gmail.com', '15 Upper Mission Drive, Kelowna, BC', 4)

    p4 = Passenger.new("Klara Utkin", "klarautkin@email.com", "4346 Gordon Dr, Kelowna, BC")
    p5 = Passenger.new("Rolan Pavlov", "rolanpavlov@email.com", "705 Kitch Rd, Kelowna, BC")
    p6 = Passenger.new("Geert Alvarsson", "geertalvarsson@email.com", "820 Guy St, Kelowna, BC")
    p7 = Passenger.new("Anina Madsen", "aninamadsen@email.com", "715 Rutland Road North, Kelowna, BC")
    p8 = Passenger.new("Gennadiz Hivkov", "gennadizhivkov@email.com", "1938 Kane Rd, Kelowna, BC")
    d2 = Driver.new("Denis Vasilyev", "denisvasilyev@email.com", "387 Bernard Avenue, Kelowna, BC", 5)

    r1 = Route.new(d1)
    r1.add_passenger(p1)
    r1.add_passenger(p2)
    r1.add_passenger(p3)

    r2 = Route.new(d2)
    r2.add_passenger(p4)
    r2.add_passenger(p5)
    r2.add_passenger(p6)
    r2.add_passenger(p7)
    r2.add_passenger(p8)

    t1.add_route(r1)
    t1.add_route(r2)

    return t1.to_json
  end

end
