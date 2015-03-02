module PagesHelper

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def create_travellers
    p1 = Passenger.new('Joe', 'joe@gmail.com', '166 Summerhill Place, Kelowna, BC')
    p2 = Passenger.new('John', 'john@gmail.com', '3333 University Way, Kelowna, BC')
    p3 = Passenger.new('Mark', 'mark@gmail.com', '1 Ellis Street, Kelowna, BC')
    d1 = Driver.new('Luke', 'luke@gmail.com', '15 Upper Mission Drive, Kelowna, BC', 4)

    r1 = Route.new(d1)

    r1.add_passenger(p2)
    r1.add_passenger(p1)
    r1.add_passenger(p3)

    t1 = Trip.new('Vernon, BC', '2015-03-29')
    t1.add_route(r1)

    return t1.to_json
  end

end
