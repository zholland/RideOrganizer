module PagesHelper

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def create_travellers

    t1 = Trip.new('Vernon, BC', '2015-03-29')

    p1 = PassengerContainer.new('Joe', 'joe@gmail.com', '166 Summerhill Place, Kelowna, BC')
    p2 = PassengerContainer.new('John', 'john@gmail.com', '3333 University Way, Kelowna, BC')
    p3 = PassengerContainer.new('Mark', 'mark@gmail.com', '1 Ellis Street, Kelowna, BC')
    d1 = DriverContainer.new('Luke', 'luke@gmail.com', '15 Upper Mission Drive, Kelowna, BC', 4)

    p4 = PassengerContainer.new("Klara Utkin", "klarautkin@email.com", "4346 Gordon Dr, Kelowna, BC")
    p5 = PassengerContainer.new("Rolan Pavlov", "rolanpavlov@email.com", "705 Kitch Rd, Kelowna, BC")
    p6 = PassengerContainer.new("Geert Alvarsson", "geertalvarsson@email.com", "820 Guy St, Kelowna, BC")
    p7 = PassengerContainer.new("Anina Madsen", "aninamadsen@email.com", "715 Rutland Road North, Kelowna, BC")
    p8 = PassengerContainer.new("Gennadiz Hivkov", "gennadizhivkov@email.com", "1938 Kane Rd, Kelowna, BC")
    d2 = DriverContainer.new("Denis Vasilyev", "denisvasilyev@email.com", "387 Bernard Avenue, Kelowna, BC", 5)

    d3 = DriverContainer.new('Luke', 'luke@gmail.com', '15 Upper Mission Drive, Kelowna, BC', 4)
    p9 = PassengerContainer.new('Joe', 'joe@gmail.com', '166 Summerhill Place, Kelowna, BC')
    p10 = PassengerContainer.new('John', 'john@gmail.com', '3333 University Way, Kelowna, BC')
    p11 = PassengerContainer.new('Mark', 'mark@gmail.com', '1 Ellis Street, Kelowna, BC')

    r1 = Oldroute.new(d1)
    r1.add_passenger(p1)
    r1.add_passenger(p2)
    r1.add_passenger(p3)

    r2 = Oldroute.new(d2)
    r2.add_passenger(p4)
    r2.add_passenger(p5)
    r2.add_passenger(p6)
    r2.add_passenger(p7)
    r2.add_passenger(p8)

    r3 = Oldroute.new(d3)
    r3.add_passenger(p9)
    r3.add_passenger(p10)
    r3.add_passenger(p11)

    t1.add_route(r1)
    t1.add_route(r2)
    t1.add_route(r3)

    return t1.to_json
  end

end
