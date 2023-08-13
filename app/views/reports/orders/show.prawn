prawn_document(info: { Title: "#{ @order&.client&.name }" }) do |pdf|  

  dir = "#{Rails.root}/app/assets/images/"

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
  @shirts = @order.shirts

  header = [
      [{image: "#{dir}logo.png",  scale: 0.1, rowspan: 3}, "CUSTOMER: #{name}", "JO Number: #{ @order&.jo_number }", "1st Fitting: #{ first_fitting }"],
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
  pdf.move_down 8

  if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Coat Maker"

    @coats.each do |coat|

      single_breasted = "X" if coat.breast == "Single Breasted"
      double_breasted = "X" if coat.breast ==  "Double Breasted"

      cbody = [
        [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "Coat         [#{single_breasted}] SINGLE BREASTED   [#{double_breasted}] DOUBLE BREASTED", colspan: 6}, {content: "CONTROL NO:#{ }", colspan: 2}],
        ["Jacket length: #{coat&.jacket_length}", "Back Width: #{coat&.back_width}", "Sleeves: #{coat&.sleeves}", "Cuffs: #{coat&.cuffs_1}/#{coat&.cuffs_2}", "Collar: #{coat&.collar}", "Chest: #{coat&.chest}", "Waist: : #{coat&.waist}", "Hips: #{coat&.hips}"],
        ["Notch: #{coat&.notch}", "Vent: #{coat&.vent}", "Double Breasted: #{coat&.double_breasted}", "Peak: #{coat&.peak}", "Shawl: #{coat&.shawl}", {content: "", colspan: 5}],
        [{content: "Remarks: #{coat&.remarks}", colspan: 10}]
      ]

      pdf.table(cbody) do
        cells.borders = [:left, :right, :top, :bottom]
        cells.style(:padding => 2, :border_width => 2, size: 10)
    
        column(0..10).width = 52
    
        row(0..5).style font_style: :bold
      end 
    end

    pdf.move_down 8

  end


  if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Pants Maker"

    @pants.each do |pant|

      pleats_pockets = "X" if pant.pleats == "PLEATS TOWARDS POCKETS"
      pleats_fly = "X" if pant.pleats == "PLEATS TOWARDS FLY"
      pleats_no = "X" if pant.pleats == "NO PLEATS"
      pleats_back = "X" if pant.pleats == "BACK POCKETS"

      cbody = [
        [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "Pants/Trousers: [#{pleats_pockets}] PLEATS TOWARDS POCKETS   [#{pleats_fly}] PLEATS TOWARDS FLY   [#{pleats_no}] NO PLEATS   [#{pleats_back}] BACK POCKETS", colspan: 6}, {content: "CONTROL NO:#{ }", colspan: 2}],
        ["Crotch: #{pant&.crotch}", "Outseam: #{pant&.outsteam}", "Waist: #{pant&.waist}", "Seat: #{pant&.seat}", "Thigh: #{pant&.thigh}", "Knee: #{pant&.knee}", "Bottom: #{pant&.remarks}"],
        [{content: "Remarks: #{pant&.remarks}", colspan: 10}]
      ]

      pdf.table(cbody) do
        cells.borders = [:left, :right, :top, :bottom]
        cells.style(:padding => 2, :border_width => 2, size: 10)
    
        column(0..10).width = 52
    
        row(0..5).style font_style: :bold
      end 
    end

    pdf.move_down 8

  end


  if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Shirt Maker"

    @shirts.each do |shirt|

      shirting = "X" if shirt.shirting_barong == "SHIRTING"
      barong = "X" if shirt.shirting_barong == "BARONG"
      tux = "X" if shirt.shirting_barong == "TUX SPECS FORM"

      cbody = [
        [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "[#{shirting}] SHIRTING   [#{barong}] BARONG   [#{tux}] TUX SPECS FORM", colspan: 6}, {content: "CONTROL NO:#{ }", colspan: 2}],
        [{content: "Fabric label: #{shirt&.fabric_label}", colspan: 3}, {content: "Tafetta: #{shirt&.tafetta}", rowspan: 2, colspan: 3 }, {content: "Fabric_code: #{shirt&.fabric_code}", rowspan: 2, colspan: 2 }, {content: "Lining_code: #{shirt&.lining_code}", rowspan: 2, colspan: 2 } ],
        [{content: "Brand label: #{shirt&.brand_label}", colspan: 3}],
        ["Pleats: #{shirt&.pleats}", "Placket: #{shirt&.placket}"],
        ["Sleeves: #{shirt&.sleeves}", "Cuffs: #{shirt&.cuffs}"],
        ["Pocket: #{shirt&.pocket}"],
        ["Bottom: #{shirt&.bottom}"],
        [{content: "Remarks: #{shirt&.remarks}", colspan: 10}]
      ]

      pdf.table(cbody) do
        cells.borders = [:left, :right, :top, :bottom]
        cells.style(:padding => 2, :border_width => 2, size: 10)
    
        column(0..10).width = 52
    
        row(0..5).style font_style: :bold
      end 
    end
  end

end

# .style(:padding => 0, :border_width => 2)
# cells.style size: 10
