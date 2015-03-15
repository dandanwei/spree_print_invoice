data = []

if @hide_prices
  @column_widths = { 0 => 100, 1 => 165, 2 => 75, 3 => 75 }
  @align = { 0 => :left, 1 => :left, 2 => :right, 3 => :right }
  data << [Spree.t(:sku), Spree.t(:item_description), Spree.t(:options), Spree.t(:qty)]
else
  @column_widths = { 0 => 75, 1 => 205, 2 => 75, 3 => 50, 4 => 75, 5 => 60 }
  @align = { 0 => :left, 1 => :left, 2 => :left, 3 => :right, 4 => :right, 5 => :right}
  data << [Spree.t(:sku), Spree.t(:item_description), Spree.t(:options), Spree.t(:price), Spree.t(:qty), Spree.t(:total)]
end

@order.line_items.each do |item|
  row = [ item.variant.sku, item.variant.product.name]
  row << item.variant.options_text
  row << item.single_display_amount.to_s unless @hide_prices
  row << item.quantity
  row << item.display_total.to_s unless @hide_prices
  data << row
end

extra_row_count = 0

unless @hide_prices
  extra_row_count += 1
  data << [""] * 5
  data << [nil, nil, nil, nil, Spree.t(:subtotal), @order.display_item_total.to_s]

  if @order.line_item_adjustments.exists?
    if @order.all_adjustments.promotion.eligible.exists?
      @order.all_adjustments.promotion.eligible.group_by(&:label).each do |label, adjustments|
        extra_row_count += 1
        data << [nil, nil, nil, Spree.t(:promotion), label, Spree::Money.new(adjustments.sum(&:amount), currency: @order.currency).to_s]
      end
    end
  end
  
  @order.shipments.group_by { |s| s.selected_shipping_rate.try(:name) }.each do |name, shipments|
    extra_row_count += 1
    data << [nil, nil, nil, nil, name, Spree::Money.new(shipments.sum(&:discounted_cost), currency: @order.currency).to_s]
                                                        #shipment.display_cost  ??
  end
  
  if @order.all_adjustments.eligible.tax.exists?
    @order.all_adjustments.eligible.tax.group_by(&:label).each do |label, adjustments|
      extra_row_count += 1
      data << [nil, nil, nil, nil, label, Spree::Money.new(adjustments.sum(&:amount), currency: @order.currency).to_s]
    end
  end
  
  @order.adjustments.eligible.each do |adjustment|
    next if (adjustment.source_type == 'Spree::TaxRate') and (adjustment.amount == 0)
    extra_row_count += 1
    data << [nil, nil, nil, nil, label, adjustment.display_amount.to_s]
  end
  
  
  if @order.all_adjustments.tax.size == 0
    extra_row_count += 1
    data << [nil, nil, nil, nil, "VAT 0%", "0"]
  end

  data << [nil, nil, nil, nil, Spree.t(:total), @order.display_total.to_s]
  
  extra_row_count += 1
  if @order.payment_state == "paid"
    @order.payments.valid.each do |payment|
      data << [nil, "Payment completed with "+payment.payment_method.name + ".", Spree::Money.new(payment.amount, currency: @order.currency).to_s, nil, nil, nil]
    end
  else
    data << [nil, "Balance due", nil, nil, nil, nil]
  end
  
end

move_down(250)
table(data, :width => @column_widths.values.compact.sum, :column_widths => @column_widths) do
  cells.border_width = 0.5

  row(0).borders = [:bottom]
  row(0).font_style = :bold

  last_column = data[0].length - 1
  row(0).columns(0..last_column).borders = [:top, :right, :bottom, :left]
  row(0).columns(0..last_column).border_widths = [0.5, 0, 0.5, 0.5]

  row(0).column(last_column).border_widths = [0.5, 0.5, 0.5, 0.5]

  if extra_row_count > 0
    extra_rows = row((-2-extra_row_count)..-2)
    extra_rows.columns(0..5).borders = []
    extra_rows.column(4).font_style = :bold

    row(-1).columns(0..5).borders = []
    row(-1).column(4).font_style = :bold
  end
end
