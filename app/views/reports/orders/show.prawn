prawn_document(info: { Title: "@person.full_name_ordered" }) do |pdf|  


  order_date = @order&.created_at
  mto = "X" if @order&.MTO_labor == "MTO"
  labor =  "X" if @order&.MTO_labor == "Labor"
  first_fitting = @order&.first_fitting
  second_fitting = @order&.second_fitting
  finish = @order&.finish

  client = @order&.client
  name = client&.name
  contact = client&.contact
  email = client&.email
  address = client&.address
  old_client = "X" if client.orders.count > 1

  @coats = @order.coats
  @pants = @order.pants

  header = [
      [{content: "Tinos", rowspan: 3}, "CUSTOMER: #{name}", "JO Number", "1st Fitting: #{ first_fitting }"],
      [{content: "CONTACT: #{contact} \n EMAIL: #{email} \n ADDRESS: #{address}", rowspan: 2}, "Date: #{ order_date }", "2nd Fitting: #{ second_fitting }"],
      ["[#{mto}] MTO \n [#{old_client}] OLD CLIENT \n [#{labor}] LABOR", "Finish: #{ finish }"],
      ["ITEM", "QTY", "FABRIC & LINING CODE", {content: "", rowspan: 5}],
    ]


  @coats.each do |coat|
    header << ["Coat", "#{coat.quantity}", "Fabric: #{ coat.fabric_code } Lining: #{ coat.lining_code }"]
  end

  @pants.each do |pant|
    header << ["Pants", "#{pant.quantity}", "Fabric: #{ pant.fabric_code } Lining: #{ pant.lining_code }"]
  end

  
  pdf.table(header) do
    cells.borders = [:left, :right, :top, :bottom]
    cells.style(:padding => 2, :border_width => 2, size: 10)

    column(0).width = 100
    column(1..3).width = 140

    row(0..5).style font_style: :bold
  end    

end

# .style(:padding => 0, :border_width => 2)
# cells.style size: 10
