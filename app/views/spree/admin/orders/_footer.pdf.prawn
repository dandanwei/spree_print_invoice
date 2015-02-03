# data = [
#   [Spree.t(:footer_left), Spree.t(:footer_left2), Spree.t(:footer_right), Spree.t(:footer_right2)]
# ]

# table(data)

#text Spree::PrintInvoice::Config[:seller_info]

data = [
  [Spree::PrintInvoice::Config[:seller_info1], Spree::PrintInvoice::Config[:seller_info2], Spree::PrintInvoice::Config[:seller_info3]]
]

table(data)  do
  row(0).column(0).borders = [:top, :right, :bottom, :left]
  row(0).column(0).border_widths = [0.5, 0, 0, 0] 
  
  row(0).column(1).borders = [:top, :right, :bottom, :left]
  row(0).column(1).border_widths = [0.5, 0, 0, 0] 
  
  row(0).column(2).borders = [:top, :right, :bottom, :left]
  row(0).column(2).border_widths = [0.5, 0, 0, 0] 
end
