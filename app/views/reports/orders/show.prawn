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

  pdf.move_down 4

  @coats.each do |coat|

    single_breasted = "X" if coat.breast == "Single Breasted"
    double_breasted = "X" if coat.breast ==  "Double Breasted"

    cbody = [
      [{content: "Coat         [#{single_breasted}] SINGLE BREASTED   [#{double_breasted}] DOUBLE BREASTED", colspan: 10}],
      ["Jacket length: #{coat&.jacket_length}", "Back Width: #{coat&.back_width}", "Sleeves: #{coat&.sleeves}", "Cuffs: #{coat&.cuffs_1}/#{coat&.cuffs_2}", "Collar: #{coat&.collar}", "Chest: #{coat&.chest}", "Waist: : #{coat&.waist}", "Hips: #{coat&.hips}", {content: "Remarks: #{coat&.remarks}", colspan: 2}],
      ["Notch: #{coat&.notch}", "Vent: #{coat&.vent}", "Double Breasted: #{coat&.double_breasted}", "Peak: #{coat&.peak}", "Shawl: #{coat&.shawl}", {content: "", colspan: 5}]
    ]

    pdf.table(cbody) do
      cells.borders = [:left, :right, :top, :bottom]
      cells.style(:padding => 2, :border_width => 2, size: 10)
  
      column(0..10).width = 52
  
      row(0..5).style font_style: :bold
    end 
  end

  pdf.move_down 4

  @pants.each do |pant|

    cbody = [
      [{content: "Pants/Trousers", colspan: 2}, {content: "Pants/Trousers", colspan: 8}],
      ["Crotch: #{pant&.crotch}", "Outseam: #{pant&.outsteam}", "Waist: #{pant&.waist}", "Seat: #{pant&.seat}", "Thigh: #{pant&.thigh}", "Knee: #{pant&.knee}", "Bottom: #{pant&.remarks}", {content: "Remarks: #{pant&.remarks}", colspan: 3}]
    ]

    pdf.table(cbody) do
      cells.borders = [:left, :right, :top, :bottom]
      cells.style(:padding => 2, :border_width => 2, size: 10)
  
      column(0..10).width = 52
  
      row(0..5).style font_style: :bold
    end 
  end

end

# .style(:padding => 0, :border_width => 2)
# cells.style size: 10
