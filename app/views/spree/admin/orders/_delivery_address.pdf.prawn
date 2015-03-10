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
  info += "#{address.zipcode} #{address.city} #{address.state}\n"
  info += "#{address.country.name} (#{address.country.iso})\n"
  info.strip
end

font "Helvetica", :size => 12
text_box address_info(ship_address),
          :at => [350, 620],
          :width => 200,
          :height => 100 

stroke_line [0, 450], [540, 450]

