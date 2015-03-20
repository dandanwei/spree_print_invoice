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
  info += "#{address.country.name}\n"
  if @hide_prices
    info += "#{address.phone}\n"
  end
  info.strip
end

if @hide_prices
  data = [
    [Spree.t(:billing_address), Spree.t(:shipping_address)], 
    [address_info(bill_address), address_info(ship_address) + "\n\nvia #{@order.shipments.first.shipping_method.name}"]
  ]
else
  data = [
    [Spree.t(:billing_address), Spree.t(:shipping_address)], 
    [address_info(bill_address)+ "\n#{bill_address.phone}\n", address_info(ship_address)]
  ]
end

if @hide_prices
  move_down 75
  
  table(data, :width => 540) do
    row(0).font_style = :bold
  
    # Billing address header
    row(0).column(0).borders = [:top, :right, :bottom, :left]
    row(0).column(0).border_widths = [0.5, 0, 0.5, 0.5]
  
    # Shipping address header
    row(0).column(1).borders = [:top, :right, :bottom, :left]
    row(0).column(1).border_widths = [0.5, 0.5, 0.5, 0]
  
    # Bill address information
    row(1).column(0).borders = [:top, :right, :bottom, :left]
    row(1).column(0).border_widths = [0.5, 0, 0.5, 0.5]
  
    # Ship address information
    row(1).column(1).borders = [:top, :right, :bottom, :left]
    row(1).column(1).border_widths = [0.5, 0.5, 0.5, 0]
  
  end  
  
else
  move_up 20
  font "Helvetica", :size => 12
  table(data, :width => 560) do
    row(0).font_style = :bold
  
    # Billing address header
    row(0).column(0).borders = [:top, :right, :bottom, :left]
    row(0).column(0).border_widths = [0, 0, 0, 0]
  
    # Shipping address header
    row(0).column(1).borders = [:top, :right, :bottom, :left]
    row(0).column(1).border_widths = [0, 0, 0, 0]
  
    # Bill address information
    row(1).column(0).borders = [:top, :right, :bottom, :left]
    row(1).column(0).border_widths = [0, 0, 0, 0]
  
    # Ship address information
    row(1).column(1).borders = [:top, :right, :bottom, :left]
    row(1).column(1).border_widths = [0, 0, 0, 0]
  
  end
  
  font @font_face,  :size => 7
  text_box @order.number, :at => [485, 580], :width => 60, :height => 8   # item value
  
  if @order.all_adjustments.tax.size == 0
    fill_color '009a44'
    fill_circle [480, 578], 2
  end  
  
end 

