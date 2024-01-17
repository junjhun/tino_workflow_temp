# add report error handling for shirt without coat

prawn_document(info: { Title: "#{ @order&.client&.name }" }) do |pdf|  

  dir = "#{Rails.root}/app/assets/images/"

  order_date = @order&.created_at
  mto = "X" if @order&.type_of_service == "Made to Order"
  labor =  "X" if @order&.type_of_service == "Bespoke Labor"
  bespoke =  "X" if @order&.type_of_service == "Bespoke"
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
        ["[#{mto}] MTO \n [#{old_client}] OLD CLIENT \n [#{labor}] LABOR \n [#{bespoke}] BESPOKE", "Finish: #{ finish }"],
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

    if @report == "Master" || @report == "Coats"

      @coats.each do |coat|

        single_breasted = "X" if coat.breast == "Single Breasted"
        double_breasted = "X" if coat.breast ==  "Double Breasted"
        style = if coat.style == "Single 1 button"
                  "#{dir}button_1.png"
                elsif coat.style == "Single 2 button"
                  "#{dir}button_2_2.png"
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

                button_spacing = if coat.button_spacing == "Stacking"
                  "#{dir}buttons_2.png"
                else
                  "#{dir}buttons_3.png"
                end

                regular = "X" if coat&.button == "Regular Button"
                horned =  "X" if coat&.button == "Horned"
                brass =  "X" if coat&.button == "Brass"
                covered =  "X" if coat&.button == "Covered"

                sfake = "X" if coat&.sleeve_buttons == "Fake"
                sfunctional = "X" if coat&.sleeve_buttons == "Functional / Surgeons"
                s2fake = "X" if coat&.sleeve_buttons == "2 Fake 2 Functional"
                noohales = "X" if coat&.sleeve_buttons == "No Ohales"

        cbody = [
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "Coat: #{ coat&.specs_form }         [#{single_breasted}] SINGLE BREASTED   [#{double_breasted}] DOUBLE BREASTED", colspan: 6}, {content: "JO Number:#{ @order.jo_number }", colspan: 2}],
          [{content: "Fabric label: #{coat&.fabric_label}", colspan: 3}, {content: "Tafetta: #{coat&.tafetta}", rowspan: 2, colspan: 2 }, {content: "Quantity: #{coat&.quantity}", rowspan: 2, colspan: 2}, {content: "BOUTONNIERE: \n\n #{ coat.boutonniere }", colspan: 3, rowspan: 2}],
          [{content: "Brand label: #{coat&.brand_label}", colspan: 3}],
          [{content: "Jacket length: #{coat&.jacket_length}", colspan: 2}, {content: "Back Width: #{coat&.back_width}", colspan: 2}, "Sleeves: #{coat&.sleeves}", {content: "Cuffs: #{coat&.cuffs_1}/#{coat&.cuffs_2}"}, "Collar: #{coat&.collar}", "Chest: #{coat&.chest}", "Waist: : #{coat&.waist}", {content: "Hips: #{coat&.hips}"}],
          [{image: pocket_type,  scale: 0.3, colspan: 2}, {image: style,  scale: 0.2, colspan: 2}, {image: lapel,  scale: 0.5, colspan: 2},{image: lining,  scale: 0.3, colspan: 2}, {content: "SLEEVES & PADDING \n\n #{ coat.sleeves_and_padding }", colspan: 2} ],

          # [{content: "#{  "x" if coat.style == "Single 1 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 2 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 3 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 4 button" }", align: :center}, {content: "#{  "x" if coat.style == "Double 4 button" }", align: :center}, {content: "#{  "x" if coat.style == "Double 6 button" }", align: :center}],
          # [{content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}],
    
          [{image: "#{dir}buttons_1.png",  scale: 0.2},  {image: button_spacing ,  scale: 0.2}, {content: "TYPE OF BUTTONS \n\n   [#{ regular }] REGULAR BUTTONS \n [#{ horned }] HORNED BUTTONS \n [#{ brass }] BRASS BUTTONS \n [#{ covered }] COVERED BUTTONS \n\n Number of buttons: #{ coat.no_of_buttons }", colspan: 4, rowspan: 2}, {content: "SLEEVES BUTTONS \n\n [#{ sfake }] FAKE \n [#{ sfunctional }] FUNCTIONAL / SURGEONS \n [#{ s2fake }] 2 FAKE 2 FUNCTIONAL \n [#{ noohales }] NO OHALES", colspan: 4, rowspan: 2}],
          [{content: "#{ coat.no_of_buttons }", align: :center}, {content: "Color: #{coat.boutonniere_color}", align: :center}],
          [{content: "MONOGRAM / LOGO \n\n", colspan: 2}, {image: front_side_pocket,  scale: 0.25, colspan: 2}, {image: vent,  scale: 0.25, colspan: 1}, {content: "Remarks: #{coat&.remarks}", colspan: 5}]
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


    if @report == "Master" || @report == "Pants"

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

        ppleats = if pant.pleat_style ==  "NO PLEAT"
          "#{dir}pleats_1.png"
        elsif pant.pleat_style ==  "SINGLE PLEATS"
          "#{dir}pleats_2.png"
        elsif pant.pleat_style ==  "TWO PLEATS"
          "#{dir}pleats_3.png"
        else
          "#{dir}pleats_4.png"
        end

        ppockets = if pant.type_of_pocket ==  "SLANTED POCKET"
          "#{dir}ppockets_1.png"
        elsif pant.type_of_pocket ==  "STRAIGHT POCKET"
          "#{dir}ppockets_2.png"
        elsif pant.type_of_pocket ==  "NACIDO POCKET"
          "#{dir}ppockets_3.png"
        else
          ""
        end

        cbody = [
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "Pants/Trousers: [#{pleats_pockets}] PLEATS TOWARDS POCKETS   [#{pleats_fly}] PLEATS TOWARDS FLY   [#{pleats_no}] NO PLEATS   [#{pleats_back}] BACK POCKETS", colspan: 6}, {content: "JO NO:#{ @order.jo_number }", colspan: 2}],
          ["Waist: #{pant&.waist}", "Seat: #{pant&.seat}", "Thigh: #{pant&.thigh}", "Knee: #{pant&.knee}", "Bottom: #{pant&.bottom}", {content: "Crotch: #{pant&.crotch}", colspan: 1}, {content: "Outseam: #{pant&.outseam}", colspan: 2}, {content: "Suspender buttons: #{pant&.add_suspender_buttons ? 'Yes' : 'No'}", colspan: 2}],
          [{content: "Pleat: #{pant&.pleats}", colspan: 2}, {content: "Quantity: #{pant&.quantity}", colspan: 1},{image: ppleats,  scale: 0.18 },  {image: back_pocket,  scale: 0.2 }, {image: pant_cuffs,  scale: 0.2 }, {image: strap,  scale: 0.2 }, {image: ppockets,  scale: 0.17}, {content: "Remarks: #{pant&.remarks}", colspan: 2}],
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


    if @report == "Master" || @report == "Shirts"

      @shirts.each_with_index do |shirt, index|
        coat = @order.coats[index]

        pleats = if shirt.pleats == "TWO SIDE PLEAT"
          "#{dir}pleats_1.png"
        elsif shirt.pleats == "CENTER PLEAT"
          "#{dir}pleats_2.png"
        elsif shirt.pleats == "NO PLEAT"
          "#{dir}pleats_3.png"
        else
          "#{dir}pleats_4.png"
        end

        spocket = if shirt.pocket == "Round"
          "#{dir}spocket_1.png"
        elsif shirt.pocket == "Agile"
          "#{dir}spocket_2.png"
        elsif shirt.pocket == "Pointed"
          "#{dir}spocket_3.png"
        elsif shirt.pocket == "Square w/ Pleats"
          "#{dir}spocket_4.png"
        elsif shirt.pocket == "w/ squared flaps"
          "#{dir}spocket_5.png"
        elsif shirt.pocket == "w/ ponted flaps"
          "#{dir}spocket_6.png"
        elsif shirt.pocket == "w/ slanted flaps"
          "#{dir}spocket_7.png"
        elsif shirt.pocket == "w/ pointed curve flaps"
          "#{dir}spocket_8.png"
        else
          "#{dir}spocket_9.png"
        end

        bottom = if shirt.bottom == "Straight Bottom"
          "#{dir}bottom_1.png"
        else
          "#{dir}bottom_2.png"
        end

        shirting = "X" if shirt.shirting_barong == "SHIRTING"
        barong = "X" if shirt.shirting_barong == "BARONG"
        tux = "X" if shirt.shirting_barong == "TUX SPECS FORM"


        single_breasted = "X" if coat.breast == "Single Breasted"
        double_breasted = "X" if coat.breast ==  "Double Breasted"
        style = if coat.style == "Single 1 button"
                  "#{dir}button_1.png"
                elsif coat.style == "Single 2 button"
                  "#{dir}button_2_2.png"
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

                button_spacing = if coat.button_spacing == "Stacking"
                  "#{dir}buttons_2.png"
                else
                  "#{dir}buttons_3.png"
                end

                regular = "X" if coat&.button == "Regular Button"
                horned =  "X" if coat&.button == "Horned"
                brass =  "X" if coat&.button == "Brass"
                covered =  "X" if coat&.button == "Covered"

                sfake = "X" if coat&.sleeve_buttons == "Fake"
                sfunctional = "X" if coat&.sleeve_buttons == "Functional / Surgeons"
                s2fake = "X" if coat&.sleeve_buttons == "2 Fake 2 Functional"
                noohales = "X" if coat&.sleeve_buttons == "No Ohales"


        cbody = [
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "[#{shirting}] SHIRTING   [#{barong}] BARONG   [#{tux}] TUX SPECS FORM", colspan: 6}, {content: "JO NO:#{ @order.jo_number }", colspan: 2}],
          [{content: "Jacket length: #{coat&.jacket_length}", colspan: 2}, {content: "Back Width: #{coat&.back_width}", colspan: 2}, "Sleeves: #{shirt&.sleeves}", {content: "Cuffs: #{coat&.cuffs_1}/#{coat&.cuffs_2}"}, "Collar: #{shirt&.collar}", "Chest: #{coat&.chest}", "Waist: : #{coat&.waist}", {content: "Hips: #{coat&.hips}"}],
          [{content: "Fabric label: #{shirt&.fabric_label}"}, {content: "Tafetta: #{shirt&.tafetta}"}, {content: "Brand label: #{shirt&.brand_label}", colspan: 2}, {content: "Number of buttons: #{shirt&.number_of_buttons}", colspan: 2}, {content: "Type of Button: #{ shirt.type_of_button }", colspan: 2}, {content: "FABRIC CONSUMPTION: #{ shirt.fabric_consumption }", colspan: 2}],

          # [{content: "#{  "x" if coat.style == "Single 1 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 2 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 3 button" }", align: :center}, {content: "#{  "x" if coat.style == "Single 4 button" }", align: :center}, {content: "#{  "x" if coat.style == "Double 4 button" }", align: :center}, {content: "#{  "x" if coat.style == "Double 6 button" }", align: :center}],
          # [{content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}, {content: "X", align: :center}],

          [{image: bottom,  scale: 0.25, colspan: 1, rowspan: 2}, {image: spocket,  scale: 0.3, colspan: 1, rowspan: 2}, {content: "Pleats: #{shirt.pleats}", colspan: 2 }, {content: "Front Placket: #{shirt&.front_placket}", colspan: 2}, {content: "Back Placket: #{shirt&.back_placket}", colspan: 2}, {content: "Lining Code: #{shirt&.lining_code}", colspan: 2}],
          [{content: "Side Placket: #{shirt&.side_placket}", colspan: 2}, {content: "Cuffs: #{ shirt.cuffs }", colspan: 2}, {content: "Quantity: #{coat&.quantity}"}, {content: "Pocket: #{shirt&.pocket }"}, {content: "Bottom: #{shirt&.bottom}", colspan: 2}],


          [{content: "Remarks: #{shirt&.remarks}", colspan: 10} ],
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

    if @report == "Master" || @report == "Vests"

      @vests.each do |vest|

        cbody = [
          [{image: "#{dir}logo.png",  scale: 0.1, colspan: 2}, {content: "VEST STYLE: #{ vest.vest_style } \n\n ADJUSTER TYPE: #{ vest.adjuster_type } \n\n LAPEL STYLE: #{ vest.lapel_style } \n\n\n NUMBER OF BUTTONS: #{ vest.number_of_front_buttons }", colspan: 4}, {image: "#{dir}logo_vest.png",  scale: 0.2, colspan: 2}, {content: "JO NO:#{ @order.jo_number }", colspan: 2}],
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
