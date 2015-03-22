require 'prawn/layout'
require 'date'

@font_face = Spree::PrintInvoice::Config[:print_invoice_font_face]

font @font_face

im = Rails.application.assets.find_asset(Spree::PrintInvoice::Config[:print_invoice_logo_path])
if @hide_prices
  image im , :at => [-20,720], :scale => logo_scale
else
  image im , :at => [0,720], :scale => logo_scale
end

fill_color "E99323"
if !@hide_prices
  text Spree.t(:customer_invoice), :align => :right, :style => :bold, :size => 18
end
fill_color "000000"

move_down 4

if Spree::PrintInvoice::Config.use_sequential_number? && @order.invoice_number.present? && !@hide_prices

  move_up 5
  font @font_face,  :size => 9,  :style => :bold
  text "#{Spree.t(:order_number, :number => @order.number)}", :align => :right

  text "#{Spree.t(:invoice_number)} #{@order.invoice_number}", :align => :right

  move_down 2
  font @font_face, :size => 9
  text "#{Spree.t(:invoice_date)} #{I18n.l @order.invoice_date}", :align => :right
  
  move_down 7
end

if @hide_prices
  
  fill_color '000000'
  font_size 9
  text_box "#{@order.number}",
            :at => [450, 540],
            :width => 60,
            :height => 20
  render :partial => "delivery_address"
  
  
  # if no tax charged --> need CN22
  if @order.all_adjustments.tax.size == 0
    fill_color '009a44'
    fill_circle [450, 395], 3
    
    fill_color '000000'
    # add cn22
    if Spree::PrintInvoice::Config[:cn22] != nil
      im2 = Rails.application.assets.find_asset(Spree::PrintInvoice::Config[:cn22])
      image im2, :at => [110,745], :height => 280 
      
      font_size 9
      text_box "X", :at => [120, 700], :width => 10, :height => 10   # Custom's declaration attached
      text_box "X", :at => [192, 682], :width => 10, :height => 10   # Other 
      
      if Spree::PrintInvoice::Config[:eori] != nil
        text_box Spree::PrintInvoice::Config[:eori], :at => [140, 580], :width => 100, :height => 10   # EORI
      end
      
      sek_usd = Spree::PrintInvoice::Config[:sek_usd]
      
      text_box DateTime.now.strftime("%Y/%m/%d"), :at => [140, 485], :width => 100, :height => 10   # Date
      
      #text_box ('%.0f' % (sek_usd*@order.total)), :at => [253, 600], :width => 30, :height => 10  # total value
      
      font_size 7
      yaxis = 655
      total_weight = 0.0
      total_value = 0.0
      all_hts = ''
      @order.line_items.each do |item|
        mstr = item.variant.product.meta_keywords.match(/PN:(?<pn>[A-Za-z0-9\s]*);/)
        product_name = mstr[:pn]      
        desc = item.quantity.to_s + "  x  " + product_name
        text_box desc, :at => [120, yaxis], :width => 105, :height => 8   # quantity and item description
        
        item_weight = 1.0 * item.quantity * item.variant.weight
        total_weight += item_weight
        text_box ('%.3f' % item_weight), :at => [230, yaxis], :width => 30, :height => 8   # item weight
        
        item_value = sek_usd*item.price*item.quantity
        total_value += item_value
        text_box ('%.0f' % item_value), :at => [253, yaxis], :width => 30, :height => 8   # item value
        
        #HS tariff
        str = item.variant.product.meta_keywords.match(/HS:(?<num>\d{6});/)
        hst = str[:num]
        if all_hts.match(hst) == nil
          if all_hts != ''
            all_hts += ';  '
          end
          all_hts += hst
        end
        
        yaxis -= 8
      end
      
      text_box ('%.3f' % total_weight), :at => [230, 600], :width => 30, :height => 10  # total weight
      text_box ('%.0f' % total_value), :at => [253, 600], :width => 30, :height => 10  # total value
      
      text_box (all_hts + '   Sweden'), :at => [120, 600], :width => 100, :height => 10  # total HS tariff
      
    end
    
  end
  
  move_down 300
  
  fill_color '000000'
  
  text Spree.t(:packaging_slip), :align => :right, :style => :bold, :size => 16

  move_down 2
  font @font_face,  :size => 9
  text "#{Spree.t(:order_number, :number => @order.number)}", :align => :right

  move_down 2
  font @font_face, :size => 9
  text "#{I18n.l @order.completed_at.to_date}", :align => :right  
  
  move_up 50
end

font @font_face, :size => 9
render :partial => "address"

font @font_face, :size => 9

if @hide_prices
  move_down 230
else
  move_down 20
end

render :partial => "line_items_box"



# Footer
if !@hide_prices
  move_down 650
  render :partial => "footer"
  
  stroke_line [-20, 460], [-10, 460]
  stroke_line [550, 460], [560, 460]
  stroke_line [-20, 170], [-10, 170]
  stroke_line [550, 170], [560, 170]  
  
end

