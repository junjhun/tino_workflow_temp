prawn_document(info: { Title: "#{ @order&.client&.name }" }) do |pdf|  

  dir = "#{Rails.root}/app/assets/images/"

  order_date = @order&.created_at
  mto = "X" if @order&.type_of_service == "MTO"
  labor =  "X" if @order&.type_of_service == "Labor"
  first_fitting = @order&.first_fitting
  second_fitting = @order&.second_fitting
  finish = @order&.finish

  client = @order&.client

  if client.nil?


    
  else

    name = client&.name
    contact = client&.contact
    email = client&.email
    address = client&.address
    old_client = "X" if client.orders.count > 1

    @coats = @order.coats
    @pants = @order.pants
    @shirts = @order.shirts
    @vests = @order.vests

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

    @shirts.each do |shirt|
      header << ["Shirts", "#{shirt.quantity}", "Fabric: #{ shirt.fabric_code } Lining: #{ shirt.lining_code }"]
    end

    @vests.each do |vest|
      header << ["Vest", "#{vest.quantity}", "Fabric: #{ vest.fabric_code } Lining: #{ vest.lining_code }"]
    end

    
    pdf.table(header) do
      cells.borders = [:left, :right, :top, :bottom]
      cells.style(:padding => 2, :border_width => 2, size: 8)

      column(0).width = 100
      column(1..3).width = 140

      row(0..5).style font_style: :bold
    end 
    pdf.move_down 8

    if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Coat Maker"

      @coats.each do |coat|

        single_breasted = "X" if coat.breast == "Single Breasted"
        double_breasted = "X" if coat.breast ==  "Double Breasted"
        style = if coat.style == "Single 1 button"
                  "#{dir}button_1.png"
                elsif coat.style == "Single 2 button"
                  "#{dir}button_2.png"
                elsif coat.style == "Single 3 button"
                  "#{dir}button_3.png"
                elsif coat.style == "Single 4 button"
                  "#{dir}button_4.png"
                elsif coat.style == "Double 4 button"
                  "#{dir}button_5.png"
                else
                  "#{dir}button_6.png"
                end

        lapel = if coat.lapel_style == "Notch"
                  "#{dir}lapel_1.png"
                elsif coat.lapel_style == "Peak"
                  "#{dir}lapel_2.png"
                elsif coat.lapel_style == "Notch Tuxedo"
                  "#{dir}lapel_3.png"
                elsif coat.lapel_style == "Peaky Shiny"
                  "#{dir}lapel_4.png"
                elsif coat.lapel_style == "Shawl"
                  "#{dir}lapel_5.png"
                else
                  "#{dir}lapel_6.png"
                end

                vent = if coat.vent == "No Vent"
                  "#{dir}vent_1.png"
                elsif coat.vent == "Center Vent"
                  "#{dir}vent_2.png"
                else
                  "#{dir}vent_3.png"
                end

                lining = if coat.lining == "Unlined"
                  "#{dir}lining_1.png"
                elsif coat.lining == "Half-lined"
                  "#{dir}lining_2.png"
                else
                  "#{dir}lining_3.png"
                end

                lining = if coat.lining == "Unlined"
                  "#{dir}lining_1.png"
                elsif coat.lining == "Half-lined"
                  "#{dir}lining_2.png"
                else
                  "#{dir}lining_3.png"
                end

                pocket_type = if coat.pocket_type == "Curved Chest Pocket"
                  "#{dir}pocket_type_1.png"
                elsif coat.pocket_type == "Flat Chest Pocket"
                  "#{dir}pocket_type_2.png"
                elsif coat.pocket_type == "Chest Patch Pocket"
                  "#{dir}pocket_type_3.png"
                else
                  "#{dir}pocket_type_4.png"
                end

                front_side_pocket = if coat.front_side_pocket == "No Pocket"
                  "#{dir}pockets_1.png"
                elsif coat.front_side_pocket == "2 Pockets"
                  "#{dir}pockets_2.png"
                elsif coat.front_side_pocket == "3 Pockets (w/ticket pocket)"
                  "#{dir}pockets_3.png"
                elsif coat.front_side_pocket == "2 Patch Pockets"
                  "#{dir}pockets_4.png"
                elsif coat.front_side_pocket == "Pockets with flaps?"
                  "#{dir}pockets_5.png"
                elsif coat.front_side_pocket == "Hacking/Italian Pocket?"
                  "#{dir}pockets_6.png"
                else
                  "#{dir}pockets_7.png"
                end

        cbody = [
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "Coat         [#{single_breasted}] SINGLE BREASTED   [#{double_breasted}] DOUBLE BREASTED", colspan: 6}, {content: "CONTROL NO:#{ coat.control_no }", colspan: 2}],
          [{content: "Fabric label: #{coat&.fabric_label}", colspan: 3}, {content: "Tafetta: #{coat&.tafetta}", rowspan: 2, colspan: 2 }, {content: "Fabric_code: #{coat&.fabric_code}", rowspan: 2, colspan: 2 }, {content: "Lining_code: #{coat&.lining_code}", rowspan: 2, colspan: 2 }, {content: "Quantity: #{coat&.quantity}", rowspan: 2}],
          [{content: "Brand label: #{coat&.brand_label}", colspan: 3}],
          [{image: pocket_type,  scale: 0.3, colspan: 2}, {image: style,  scale: 0.3, colspan: 2}, {image: lapel,  scale: 0.5, colspan: 2},{image: lining,  scale: 0.3, colspan: 2}, {content: "SLEEVES & PADDING \n\n #{ coat.sleeves_and_padding }", colspan: 2} ],

          # [{content: "#{  "x" if coat.style == "Single 1 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 2 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 3 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 4 button" }", align: :center}, {content: "#{  "x" if coat.style == "Double 4 button" }", align: :center}, {content: "#{  "x" if coat.style == "Double 6 button" }", align: :center}],
          # [{content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}],
    
          [{image: "#{dir}buttons_1.png",  scale: 0.2}, {image: "#{dir}buttons_2.png",  scale: 0.2}, {image: "#{dir}buttons_3.png",  scale: 0.2}, {image: "#{dir}buttons_4.png",  scale: 0.18}, {content: "BUTTONS \n\n   HORN BUTTONS \n REG BUTTONS \n COVERED BUTTONS", colspan: 3, rowspan: 2}, {content: "SLEEVES BUTTONS \n\n FAKE \n FUNCTIONAL / SURGEONS \n 2 FAKE 2 FUNCTIONAL \n NO OHALES", colspan: 3, rowspan: 2}],
          [{content: "#{ coat.no_of_buttons }", align: :center}, {content: "#{ "x" if coat.button_spacing == "Stacking" }", align: :center}, {content: "#{ "x" if coat.button_spacing == "kissing" }", align: :center}, {content: coat.boutonniere_color, align: :center}],
          ["Jacket length: #{coat&.jacket_length}", "Back Width: #{coat&.back_width}", "Sleeves: #{coat&.sleeves}", "Cuffs: #{coat&.cuffs_1}/#{coat&.cuffs_2}", "Collar: #{coat&.collar}", "Chest: #{coat&.chest}", "Waist: : #{coat&.waist}", "Hips: #{coat&.hips}", {content: "BOUTONNIERE: \n\n #{ coat.boutonniere }", colspan: 2}],
          [{content: "MONOGRAM / LOGO \n\n", colspan: 2}, {content: "ADDITIONAL SPEC \n\n DOUBLE TRIAGULAR FLAPS / with BUTTONS \n EPAULETS \n BODY BELT W/ BELTLOOP", colspan: 2}, {image: front_side_pocket,  scale: 0.25, colspan: 2}, {image: vent,  scale: 0.25, colspan: 1}, {content: "Remarks: #{coat&.remarks}", colspan: 3}]
        ]

        pdf.table(cbody) do
          cells.borders = [:left, :right, :top, :bottom]
          cells.style(:padding => 2, :border_width => 2, size: 8)
      
          column(0..10).width = 52
      
          row(0..8).style font_style: :bold
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

        back_pocket = if pant.back_pocket == "No Back Pocket"
          "#{dir}back_1.png"
        elsif pant.back_pocket == "2 Back Pocket"
          "#{dir}back_2.png"
        elsif pant.back_pocket == "1 left Back Pocket"
          "#{dir}back_3.png"
        elsif pant.back_pocket == "1 right Back Pocket"
          "#{dir}back_4.png"
        elsif pant.back_pocket == "Pockets with Button?"
          "#{dir}back_5.png"
        else
          "#{dir}back_6.png"
        end

        pant_cuffs = if pant.pant_cuffs == "No pant cuffs"
          "#{dir}pant_cuffs_1.png"
        elsif pant.back_pocket == "With pant cuffs"
          "#{dir}pant_cuffs_2.png"
        else
          "#{dir}pant_cuffs_3.png"
        end

        strap = if pant.strap == "No overlap / no extended strap"
          "#{dir}strap_1.png"
        elsif pant.strap == "Extended Overlap / Pointed Strap / 1 Button"
          "#{dir}strap_2.png"
        elsif pant.strap == "Extended Overlap / Squared Strap / 2 Button"
          "#{dir}strap_3.png"
        elsif pant.strap == "Thick waistband"
          "#{dir}strap_4.png"
        else
          "#{dir}strap_5.png"
        end

        cbody = [
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "Pants/Trousers: [#{pleats_pockets}] PLEATS TOWARDS POCKETS   [#{pleats_fly}] PLEATS TOWARDS FLY   [#{pleats_no}] NO PLEATS   [#{pleats_back}] BACK POCKETS", colspan: 6}, {content: "CONTROL NO:#{ pant.control_no }", colspan: 2}],
          [{content: "Fabric label: #{pant&.fabric_label}", colspan: 2}, {content: "Tafetta: #{pant&.tafetta}", colspan: 2   }, {content: "Add suspender buttons: #{pant&.add_suspender_buttons}", colspan: 1}, {content: "Fabric_code: #{pant&.fabric_code}", colspan: 2 }, {content: "Lining_code: #{pant&.lining_code}", colspan: 2 }, {content: "Quantity: #{pant&.quantity}"} ],
          [{image: "#{dir}pleats_1.png",  scale: 0.2}, {image: "#{dir}pleats_2.png",  scale: 0.2}, {image: "#{dir}pleats_3.png",  scale: 0.2}, {image: "#{dir}pleats_4.png",  scale: 0.2}, {image: "#{dir}pleats_1.png",  scale: 0.2}, {image: "#{dir}ppockets_1.png",  scale: 0.2}, {image: "#{dir}ppockets_2.png",  scale: 0.2}, {image: "#{dir}ppockets_3.png",  scale: 0.18}, "Crotch: #{pant&.crotch}", "Outseam: #{pant&.outseam}"],
          [{content: "#{ "X" if pant.pleats ==  "PLEATS TOWARDS POCKETS"}"}, {content: "#{ "X" if pant.pleats ==  "PLEATS TOWARDS FLY"}"}, {content: "#{ "X" if pant.pleats ==  "NO PLEATS"}"}, {content: "#{ "X" if pant.pleats ==  "BACK POCKETS"}"}, {}, {}, {content: "#{ "X" if pant.pleats ==  "PLEATS TOWARDS POCKETS"}"}, {content: "#{ "X" if pant.pleats ==  "PLEATS TOWARDS FLY"}"}, {content: "#{ "X" if pant.pleats ==  "NO PLEATS"}"}, {content: "#{ "X" if pant.pleats ==  "BACK POCKETS"}"}],
          [{content: "Brand label: #{pant&.brand_label}", colspan: 1},  {image: back_pocket,  scale: 0.2, colspan: 1 }, {image: pant_cuffs,  scale: 0.2, colspan: 1 }, {image: strap,  scale: 0.2, colspan: 1 }, "Waist: #{pant&.waist}", "Seat: #{pant&.seat}", "Thigh: #{pant&.thigh}", "Knee: #{pant&.knee}", "Bottom: #{pant&.bottom}", {content: "Remarks: #{pant&.remarks}", colspan: 1}]
        ]

        pdf.table(cbody) do
          cells.borders = [:left, :right, :top, :bottom]
          cells.style(:padding => 2, :border_width => 2, size: 8)
      
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
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "[#{shirting}] SHIRTING   [#{barong}] BARONG   [#{tux}] TUX SPECS FORM", colspan: 6}, {content: "CONTROL NO:#{ shirt.control_no }", colspan: 2}],
          [{content: "Fabric label: #{shirt&.fabric_label}", colspan: 3}, {content: "Tafetta: #{shirt&.tafetta}", rowspan: 2, colspan: 2 }, {content: "Fabric_code: #{shirt&.fabric_code}", rowspan: 2, colspan: 2 }, {content: "Lining_code: #{shirt&.lining_code}", rowspan: 2, colspan: 3 } ],
          [{content: "Brand label: #{shirt&.brand_label}", colspan: 3}],
          [{content: "Front Placket: #{shirt&.front_placket}", colspan: 3}, {content: "Back Placket: #{shirt&.back_placket}", colspan: 2 }, {content: "Side Placket: #{shirt&.side_placket}", colspan: 2 }, {content: "Pocket: #{shirt&.pocket}", colspan: 3 } ],
          [{content: "Remarks: #{shirt&.remarks}", colspan: 10}]
        ]

        pdf.table(cbody) do
          cells.borders = [:left, :right, :top, :bottom]
          cells.style(:padding => 2, :border_width => 2, size: 8)
      
          column(0..10).width = 52
      
          row(0..5).style font_style: :bold
        end 

        pdf.move_down 8
      end
    end

    if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Vest Maker"

      @vests.each do |vest|

        cbody = [
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "VEST STYLE: #{ vest.vest_style } ADJUSTER TYPE: #{ vest.adjuster_type } LAPEL STYLE: #{ vest.lapel_style } TUX SPECS FORM", colspan: 6}, {content: "CONTROL NO:#{ vest.order_id }", colspan: 2}],
          [{content: "Side pocket: #{vest&.side_pocket}", colspan: 4}, {content: "Chest pocket: #{vest&.chest_pocket}", colspan: 2 }, {content: "Vest Length: #{vest&.vest_length}", colspan: 2 }, {content: "Back Width: #{vest&.back_width}", colspan: 2 }  ],
          [{content: "Back width: #{vest&.back_width}", colspan: 3}, {content: "Chest: #{vest&.chest}", colspan: 2 }, {content: "Waist: #{vest&.waist}", colspan: 2 }, {content: "Hips: #{vest&.hips}", colspan: 3 } ],
          [{content: "Remarks: #{vest&.remarks}", colspan: 10}]
        ]

        pdf.table(cbody) do
          cells.borders = [:left, :right, :top, :bottom]
          cells.style(:padding => 2, :border_width => 2, size: 8)
      
          column(0..10).width = 52
      
          row(0..8).style font_style: :bold
        end 
      end
    end
  end

end

# .style(:padding => 0, :border_width => 2)
# cells.style size: 8
