# Address Stuff

bill_address = @order.bill_address
ship_address = @order.ship_address
anonymous = @order.email =~ /@example.net$/


def address_info(address)
  info = %Q{
    #{address.first_name} #{address.last_name}
    #{address.address1}
  }
  info += "#{address.address2}\n" if address.address2.present?
  state = address.state ? address.state.abbr : ""
  info += "#{address.zipcode} #{address.city} #{state}\n"
  info += "#{address.country.name} (#{address.country.iso})\n"
  info.strip
end

stroke_axis

font :size => 9

font "Helvetica", :size => 14, :style => :bold
text_box "address_info(ship_address)",
          :at => [120, 600],
          :width => 130,
          :height => 100 

stroke_line [0, 490], [270, 490]
stroke_line [270, 700], [270, 490]                 

