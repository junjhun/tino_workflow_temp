#  Author: Felino Calderon
#  Email: junjhun.calderon.work@gmail.com

require 'prawn'
require 'pathname'
project_root = Pathname.new(File.expand_path('../../../../..', __FILE__)) # Adjust as needed

prawn_document(info: { Title: "#{ @order&.client&.name }" }) do |pdf|
  pdf.font_families.update(
    "DejaVu Sans" => {
      normal: project_root.join('lib', 'fonts', 'DejaVuSans', 'DejaVuSans.ttf').to_s,
      bold: project_root.join('lib', 'fonts', 'DejaVuSans', 'DejaVuSans-Bold.ttf').to_s
    }
  )
  pdf.font "DejaVu Sans"
  dir = "#{Rails.root}/app/assets/images/"

  # for overall width
  overall_table_width = pdf.bounds.width

  order_date = @order&.created_at
  first_fitting = @order&.first_fitting
  second_fitting = @order&.second_fitting
  third_fitting = @order&.third_fitting
  finish = @order&.finish
  event = @order&.event_date
  client = @order&.client

	# Types of service - initialized to unchecked checkbox
  bespoke = "\u2610"
  labor = "\u2610"
  mto = "\u2610"
  rtw = "\u2610"
  mtm = "\u2610"

	# Set checkboxes for type of service
	# u\2611 - Checked checkbox
	# u\2610 - Unchecked checkbox

  name = client&.name
  contact = client&.contact
  email = client&.email
  address = client&.address
  old_client = if client&.orders&.count > 1
    "\u2611"  # Checked checkbox if the client has more than one order
  else
    "\u2610"  # Unchecked checkbox otherwise
  end

  @coats = @order.coats
  @pants = @order.pants
  @shirts = @order.shirts
  @vests = @order.vests

	# Logo branding - default Tino
  case @order.brand_name
	  when "Olpiana Andres"
	    brandLogo = "#{dir}logo/olpiana_orig_icon_logo.png"
	    bgcolor = "ffffff"
	  when "St. James"
	    brandLogo = "#{dir}logo/st_james_icon_logo.png"
	    bgcolor = "ffffff"
	  else
	    brandLogo = "#{dir}logo/tino_bone_icon_logo.png"
	    bgcolor = "6A2323"
	    #bgcolor = "ffffff"
  end

  # Calculate total Rows of Header to dynamically rowspan Remarks - 0 based
  header_static_rows = 5
  header_total_rows = header_static_rows + @coats.count + @pants.count + @shirts.count + @vests.count

	# Header Start #######################
  header = [
    [{image: brandLogo,  fit: [100, 100], rowspan: 5}, { content: "CLIENT: #{name}", colspan: 2}, "1st FITTING: #{first_fitting}", { content: "REMARKS" }],
    [{ content: "JO #: #{ @order&.jo_number }", colspan: 2 }, "2nd FITTING: #{second_fitting}", { content: " ", rowspan: header_total_rows }],
    [{ content: "DATE: #{order_date.strftime('%Y-%m-%d')}", colspan: 2}, "3rd FITTING: #{third_fitting}"],
    [{ content: "OLD CLIENT: #{old_client}", colspan: 2}, { content: "FIN\/PICKUP DATE: #{finish}"}],
    [{ content: "TYPES OF SERVICE: #{@order.type_of_service}", colspan: 2}, {content: "EVENT: #{event}"}],
    ["ITEM", "QTY", {content: "FABRIC & LINING CODE", colspan:2 }], #for header of items
  ]

	header_row_count = header.size
  @coats.each do |coat|
    header << ["Coat", "#{coat.quantity}", {content: "Fabric: #{ coat.fabric_code } Lining: #{ coat.lining_code }", colspan: 2 }]
  end

  @pants.each do |pant|
    header << ["Pants", "#{pant.quantity}", {content: "Fabric: #{ pant.fabric_code } Lining: #{ pant.lining_code }", colspan: 2}]
  end

  @shirts.each do |shirt|
    header << ["Shirts", "#{shirt.quantity}", {content: "Fabric: #{ shirt.fabric_code } Lining: #{ shirt.lining_code }", colspan: 2}]
  end

  @vests.each do |vest|
    header << ["Vest", "#{vest.quantity}", {content: "Fabric: #{ vest.fabric_code } Lining: #{ vest.lining_code }", colspan: 2}]
  end

  data = []
  data << header


  pdf.table(header, width: overall_table_width) do
    cells.borders = [:left, :right, :top, :bottom]
    cells.style(:padding => 2, :border_width => 2, size: 8)

    cells[0,0].style(vposition: :center, position: :center, background_color: bgcolor) # logo
    cells[0,1].style(font_style: :bold) # client name
    cells[0,4].style(align: :center, font_style: :bold, size: 10) # Remarks (overall)
    cells[0,4].borders = [:left, :right, :top] # Remarks - no bottom border
    cells[1,4].borders = [:left, :right, :bottom] # space part Remarks no top border

    row(0..2).column(1).style(size: 10) # Client, JO, Date
    row(5).columns(0..2).style(size: 10, font_style: :bold) # items/qty/fabric_code header
    column(0).width = 100 # Logo
    column(1).width = 40 # QTY column
    column(2).width = 150
    # column(3).width = 100 # Fittings and fin
    column(4).width = 120 # Remarks

  end

  # Header End #################################
	pdf.move_down 5

  # Body Start ##########################
  @coats.each do |coat| # coat start
    single_breasted = "\u2610"
    double_breasted = "\u2610"
    coat.breast == "Single Breasted" ? single_breasted = "\u2611" : double_breasted = "\u2611"

    col_num = 2 # main table column count

    # setting images var
    case coat.style
      when "Single-breasted 1 button"
        coat_button_style = "#{dir}button_1.png"
      when "Single-breasted 2 buttons"
        coat_button_style = "#{dir}button_2.png"
      when "Single-breasted 3 buttons"
        coat_button_style = "#{dir}button_3.png"
      when "Single 4 button"
        coat_button_style = "#{dir}button_4.png"
      when "Double 4 button"
        coat_button_style = "#{dir}button_5.png"
      when "Double 6 button"
        coat_button_style = "#{dir}button_6.png"
      #when 'Single-breasted 3-on-2 buttons' #no image
        #coat_button_style = "#"
      #when 'Double-breasted 4-on-1 buttons' #no image
        #coat_button_style = "#"
      #when 'Double-breasted 4-on-2 buttons' #no image
        #coat_button_style = "#"
      #when 'Double-breasted 6-on-1 buttons' #no image
        #coat_button_style = "#"
      #when 'Double-breasted 6-on-2 buttons' #no image
        #coat_button_style = "#"
      else
        coat_button_style = "#{dir}x.png"
    end

    case coat.lapel_style
      when "Notch"
        coat_lapel_style = "#{dir}lapel_1.png"
      when "Peak"
        coat_lapel_style = "#{dir}lapel_2.png"
      when "Notch Tuxedo"
        coat_lapel_style = "#{dir}lapel_3.png"
      when "Peaky Shiny"
        coat_lapel_style = "#{dir}lapel_4.png"
      when "Shawl"
        coat_lapel_style = "#{dir}lapel_5.png"
      when "Lapel Trimming"
        coat_lapel_style = "#{dir}lapel_6.png"
      else
        coat_lapel_style = "#{dir}x.png"
    end

    case coat.vent
      when "No Vent"
        coat_vent_style = "#{dir}vent_1.png"
      when "1 vent (center)"
        coat_vent_style = "#{dir}vent_2.png"
      when "2 vents (side)"
        coat_vent_style = "#{dir}vent_3.png"
      else
        coat_vent_style = "#{dir}x.png"
    end

    case coat.lining
      when "Unlined_none"
        coat_lining_style = "#{dir}lining_1.png"
      when "Half_Lining"
        coat_lining_style = "#{dir}lining_2.png"
      when "Full_Lining"
        coat_lining_style = "#{dir}lining_3.png"
      #when "Quarter_Lining" #no image available
        #coat_lining_style = "#"
      else
        coat_lining_style = "#{dir}x.png"
    end

    case coat.pocket_type
      when "Curved Chest Pocket"
        coat_pocket_style = "#{dir}pocket_type_1.png"
      when "Flat Chest Pocket"
        coat_pocket_style = "#{dir}pocket_type_2.png"
      when "Patch"
        coat_pocket_style = "#{dir}pocket_type_3.png"
      when "Satin on Chest Pocket"
        coat_pocket_style = "#{dir}pocket_type_4.png"
      #when "Straight" #no image available
        coat_pocket_style = "#"
      #when "Barchetta" #no image available
        coat_pocket_style = "#"
      else
        coat_pocket_style = "#{dir}x.png"
    end

		case coat.front_side_pocket
	    when "NoPocket"
	      coat_front_side_pocket = "#{dir}pockets_1.png"
	    when "2 Pockets"
	      coat_front_side_pocket = "#{dir}pockets_2.png"
	    when "3 Pockets (w/ticket pocket)"
	      coat_front_side_pocket = "#{dir}pockets_3.png"
	    when "Patch"
	      coat_front_side_pocket = "#{dir}pockets_4.png"
	    when "Pockets with flaps?"
	      coat_front_side_pocket = "#{dir}pockets_5.png"
	    when "Hacking/Italian Pocket?"
	      coat_front_side_pocket = "#{dir}pockets_6.png"
	    when "Satin on Pockets Trimming"
	      coat_front_side_pocket = "#{dir}pockets_7.png"
      #when "Jetted" #no image
        #coat_front_side_pocket = "#"
	    else
	      coat_front_side_pocket = "#{dir}x.png"
    end

    case coat.button_spacing
	    when "Stacking"
	      coat_button_spacing = "#{dir}buttons_2.png"
	    when "Kissing"
	      coat_button_spacing = "#{dir}buttons_3.png"
	    else
	      coat_button_spacing = "#{dir}x.png"
    end

    top_row = [
      [{content: "COAT"}, "#{single_breasted} SINGLE BREASTED", "#{double_breasted} DOUBLE BREASTED"]
    ]
    header_column_widths = [50, (overall_table_width - 50) / 2.0, (overall_table_width - 50) / 2.0] # logical column width for top row

    nested_table_header = pdf.make_table(top_row, cell_style: { borders:[], padding: [2, 4, 2, 4] }, column_widths: header_column_widths) do
      cells.align = :center
      columns(0).align = :left
      columns(0).style(font_style: :bold)
    end

    header_cell = pdf.make_cell(
      content: nested_table_header,
      colspan: col_num,
      borders: [:top, :bottom, :left, :right],
      padding: 0
    ) # header outer border - as a single cell

    measurements = [
      [{content: "JACKET LENGTH"},
        {content: "BACK WIDTH"},
        {content: "SLEEVES"},
        {content: "CUFFS"},
        {content: "COLLAR"},
        {content: "CHEST"},
        {content: "WAIST"},
        {content: "HIPS"},
      ],
      [{ content: coat.jacket_length.nil? ? "N/A" : "#{coat.jacket_length}"}, #jacket_length
         { content: coat.back_width.nil? ? "N/A" : "#{coat.back_width}"}, #back_width
         { content: coat.sleeves.nil? ? "N/A" : "#{coat.sleeves}"}, #sleeves
         { content: (coat.cuffs_1.nil? && coat.cuffs_2.nil?) ? "N/A" : "R: #{coat.cuffs_1.nil? ? 'N/A' : coat.cuffs_1}\nL: #{coat.cuffs_2.nil? ? 'N/A' : coat.cuffs_2}"}, #cuffs_1 & cuffs_2
         { content: coat.collar.nil? ? "N/A" : "#{coat.collar}"}, #collar
         { content: coat.chest.nil? ? "N/A" : "#{coat.chest}"}, #chest
         { content: coat.waist.nil? ? "N/A" : "#{coat.waist}"}, #waist
         { content: coat.hips.nil? ? "N/A" : "#{coat.hips}"}, #hips
      ],
    ]
    measurements_column_widths = [ # total of 400
      50,  # JACKET LENGTH
      50,  # BACK WIDTH
      50,  # SLEEVES
      50,  # CUFFS
      50,  # COLLAR
      50,  # CHEST
      50,  # WAIST
      50,  # HIPS
    ]

    nested_table_measurements = pdf.make_table(measurements, column_widths: measurements_column_widths, width: measurements_column_widths.sum) do
      cells.align = :center
      cells.style(:padding => 2, borders: [], size: 8)
      row(0).borders = [:left, :right, :top]
      row(1).borders = [:left, :right, :bottom]
    end

    measurements_cell = pdf.make_cell(
      content: nested_table_measurements,
      colspan: col_num - 1,
      borders: [:top, :bottom, :left, :right],
      padding: 0,
    ) # as a single cell

		coat_images = [
			[{image: coat_button_style, fit:[60,60]}, # coat_button_style
			{image: coat_lapel_style, fit:[60,60]}, # coat_lapel_style
			{image: coat_vent_style, fit:[60,60]}, # coat_vent_style
			{image: coat_lining_style, fit:[60,60]}, # coat_lining_style
			{image: coat_pocket_style, fit:[60,60]}, # coat_pocket_style
			{image: coat_front_side_pocket, fit:[60,60]}, # coat_front_side_pocket
			{image: coat_button_spacing, fit:[60,60]}, # coat_button_spacing
			],
			["BUTTON","LAPEL","VENT","LINING","POCKET TYPE","FRONT\nSIDE POCKET","BUTTON\nSPACING"
			],
		]

		images_col_num = 7
    column0_table_width = 400
    column_width = column0_table_width / images_col_num

		nested_table_coat_images = pdf.make_table(coat_images, column_widths: [column_width]*images_col_num ) do
      cells.position = :center
      cells.align = :center
      cells.style(:padding => 4, borders: [], size: 8)
    end

    coat_images_cell = pdf.make_cell(
      content: nested_table_coat_images,
      colspan: col_num - 1,
      borders: [:top, :bottom, :left, :right],
      padding: 0,
    ) # outer border - treated as single cell in master table

		# POSTURE#######
		# shoulders
		shoulder_stooping = "\u2610"
		shoulder_stooping_img = "#{dir}posture/shoulders_stooping.png"
		shoulder_square = "\u2610"
		shoulder_square_img = "#{dir}posture/shoulders_square.png"
		shoulder_normal = "\u2610"
		shoulder_normal_img = "#{dir}posture/shoulders_normal.png"

		case coat.shoulders
			when "Stooping Shoulders"
				shoulder_stooping = "\u2611"
			when "Square"
				shoulder_square = "\u2611"
			else
				shoulder_normal = "\u2611"
		end

		shoulders = [
			[{image: shoulder_stooping_img, fit:[50,50]},
			{image: shoulder_square_img, fit:[50,50]},
			{image: shoulder_normal_img, fit:[50,50]}],
			[{content: "STOOPING\n#{shoulder_stooping}"},
			{content: "SQUARE\n#{shoulder_square}"},
			{content: "NORMAL\n#{shoulder_normal}"}],
		]

		#stature
		stature_erect = "\u2610"
    stature_erect_img = "#{dir}posture/stature_erect.png"
    stature_prominent_stomach = "\u2610"
    stature_prominent_stomach_img = "#{dir}posture/stature_prominent_stomach.png"
    stature_stooping = "\u2610"
    stature_stooping_img = "#{dir}posture/stature_stooping.png"
    stature_stout = "\u2610"
    stature_stout_img = "#{dir}posture/stature_stout.png"
		stature_normal = "\u2610"
    stature_normal_img = "#{dir}posture/stature_normal.png"

		case coat.stature
	    when 'Erect'
	      stature_erect = "\u2611"
	    when 'Stooping Stature'
	      stature_stooping = "\u2611"
	    when 'Prominent Stomach'
	      stature_prominent_stomach = "\u2611"
	    when 'Stout'
	      stature_stout = "\u2611"
	    else # 'Normal'
	      stature_normal = "\u2611"
    end

    stature = [
      [{image: stature_erect_img, fit: [50,50]},{image: stature_stooping_img, fit: [50,50]},{image: stature_prominent_stomach_img, fit: [50,50]},{image: stature_stout_img, fit: [50,50]},{image: stature_normal_img, fit: [50,50]}],
      [{content: "ERECT\n#{stature_erect}"},{content: "STOOPING\n#{stature_stooping}"},{content: "PROMINENT\nSTOMACH\n#{stature_prominent_stomach}"},{content: "STOUT\n#{stature_stout}"},{content: "NORMAL\n#{stature_normal}"}],
    ]

    posture = [
      stature[0]+shoulders[0],
      stature[1]+shoulders[1],
    ]

    nested_table_posture_images = pdf.make_table(posture, width: 400, column_widths: [50,50,50,50,50,50,50,50]) do
      cells.position = :center
      cells.align = :center
      cells.style(:padding => [3,2,3,0], borders: [], size: 7)
      # row(1).style(font_style: :bold)
    end

    posture_images_cell  = pdf.make_cell(
      content: nested_table_posture_images,
      colspan: col_num - 1,
      borders: [:top, :bottom, :left, :right],
      padding: 0,
    ) # outer border - treated as single cell in master table

		coat_boutonniere = (coat.boutonniere.to_s.empty? ? "N/A" : coat.boutonniere)
    coat_button = (coat.button.to_s.empty? ? "N/A" : coat.button)
    coat_sleeve_buttons = (coat.sleeve_buttons.to_s.empty? ? "N/A" : coat.sleeve_buttons)
    coat_fabric_label = (coat.fabric_label.to_s.empty? ? "N/A" : coat.fabric_label)
    coat_fabric_consumption = (coat.fabric_consumption.to_s.empty? ? "N/A" : coat.fabric_consumption)

    body = [
      [{content: header_cell, colspan: 2}],
      [measurements_cell, {content: "REMARKS\n\n#{coat.remarks}", rowspan: 2}],
      [{content: coat_images_cell}],
      [posture_images_cell, {content: "BOUTONNIERE: #{coat_boutonniere}\nBUTTON: #{coat_button}\nSLEEVE BUTTONS: #{coat_sleeve_buttons}\nFABRIC LABEL: #{coat_fabric_label}\nFABRIC CONSUMPTION: #{coat_fabric_consumption}"}],
    ]

    coat_table = pdf.make_table(body, width: overall_table_width) do
      cells.borders = [:left, :right, :top, :bottom]
      cells.style(align: :center, :padding => 0, :border_width => 2, size: 7)

      row(0).style(size: 8)
      column(0).width = 400 #nested tables
      column(1).width = 140 #Remarks
      row(1).column(1).style(font_style: :bold)
      row(1).column(0).borders = [:left, :right, :top]
      row(2).column(0).borders = [:left, :right, :bottom]
      column(1).style(padding: 4) # Remarks & Specs
      row(3).column(1).style(align: :left)
    end

		# start a new page if table will break due to remaining space
    if coat_table.height+50 > pdf.cursor
      pdf.start_new_page
    end
    coat_table.draw
  end # coat end

  @pants.each do |pant| # pant start
		top_row = [
	    [{content: "TROUSERS"},{content: "PLEATS: #{pant.pleats}"}]
	  ]

	  header_column_widths = [150, (overall_table_width -150)] # logical column width for top row

	  nested_table_header = pdf.make_table(top_row, cell_style: { borders:[], padding: [2, 4, 2, 4] }, column_widths: header_column_widths) do
	    # cells.align = :center
	    columns(0).align = :left
	    columns(0).style(font_style: :bold)
	  end

	  header_cell = pdf.make_cell(
	    content: nested_table_header,
	    borders: [:top, :bottom, :left, :right],
	    colspan: 3,
	    padding: 0,
	  ) # header outer border - as a single cell

	  measurements = [
	    [{content: "MEASUREMENTS", colspan: 2}], #header
	    ["CROTCH",{content: "#{pant.crotch}"}], #crotch
	    ["OUTSEAM",{content: "#{pant.outseam}"}], #outseam
	    ["WAIST",{content: "#{pant.waist}"}], #waist
	    ["SEAT",{content: "#{pant.seat}"}], #seat
	    ["THIGH",{content: "#{pant.thigh}"}], #thigh
	    ["KNEE",{content: "#{pant.knee}"}], #knee
	    ["BOTTOM",{content: "#{pant.bottom}"}], #bottom
	  ]

	  measurements_column_widths = [ #total of 180
	    90, # Key
	    90, # Value
    ]

    nested_table_measurements = pdf.make_table(measurements, column_widths: measurements_column_widths, width: measurements_column_widths.sum) do
      cells.style(:padding => 2, borders: [], size: 8)
      row(0).style(font_style: :bold, align: :center)
      column(0).borders = [:left, :top, :bottom]
      column(1).borders = [:top, :bottom, :right]
    end

    measurements_cell = pdf.make_cell(
      content: nested_table_measurements,
      borders: [:top, :bottom, :left, :right],
      padding: 0
    ) # as a single cell

    specifications = [
      [{content: "SPECIFICATION", colspan: 2}],
      [{content: "RISE"},{ content: pant.rise.nil? ? "None" : pant.rise }],
      [{content: "CUT"},{ content: pant.cut.nil? ? "None" : pant.cut }],
      [{content: "OVERLAP"},{ content: pant.overlap.nil? ? "None" : pant.overlap }],
      [{content: "WAIST AREA"},{ content: pant.waist_area.nil? ? "None" : pant.waist_area }],
      [{content: "CLOSURE"},{ content: pant.closure.nil? ? "None" : pant.closure }],
      [{content: "TYPE OF POCKET"},{ content: pant.type_of_pocket.nil? ? "None" : pant.type_of_pocket }],
      [{content: "BACK POCKET"},{ content: pant.back_pocket.nil? ? "None" : pant.back_pocket }],
      [{content: "FABRIC CONSUMPTION"},{ content: pant.fabric_consumption.nil? ? "None" : pant.fabric_consumption }],
    ]

    nested_table_specifications = pdf.make_table(specifications, width: 180, column_widths: [90,90]) do
      row(0).style(font_style: :bold, align: :center)
      cells.style(:padding => 2, border: [], size: 8)
    end

    specifications_cell = pdf.make_cell(
      content: nested_table_specifications,
      borders: [:top, :bottom, :left, :right],
      padding: 2,
    ) # as a single cell

	  body = [
	    [{content: header_cell, colspan: 3}],
	    [measurements_cell, specifications_cell, {content: "REMARKS\n\n#{pant.remarks}"}],
	  ]

	  pant_table = pdf.make_table(body, width: overall_table_width) do
	    cells.borders = [:left, :right, :top, :bottom]
	    cells.style(align: :center, :padding => 0, :border_width => 2, size: 7)
			column(1).width = 180 #specs
	    column(2).width = 180 #Remarks
	    column(2).style(padding: 2, font_style: :bold) # Remarks
	  end

	  # start a new page if table will break due to remaining space
    if pant_table.height+50 > pdf.cursor
      pdf.start_new_page
    end
    pant_table.draw
  end # pant end

  @vests.each do |vest| #vest start
    vest_model_top = vest.vest_model.nil? ? "NONE" : vest.vest_model
    top_row = [
      [{content: "VESTS"},{content: "MODEL: #{vest_model_top.upcase}"},]
    ]

    header_column_widths = [150, (overall_table_width -150)] # logical column width for top row

    nested_table_header = pdf.make_table(top_row, cell_style: { borders: [], padding: [2, 4, 2, 4] },
      column_widths: header_column_widths) do
      column(0).align = :left
      column(0).style(font_style: :bold)
    end

    header_cell = pdf.make_cell(
      content: nested_table_header,
      borders: [:top, :bottom, :left, :right],
      colspan: 3,
      padding: 0,
    ) # header outer border - as a single cell

    measurements = [
      [{content: "MEASUREMENTS", colspan: 2}], #header
      ["LENGTH",vest.vest_length], # vest_length
      ["BACK WIDTH",vest.back_width], # back_width
      ["CHEST",vest.chest], # chest
      ["WAIST",vest.waist], # waist
      ["HIPS",vest.hips], # hips
      ["LAPEL WIDTH",vest.lapel_width], # lapel_width
    ]

    measurements_column_widths = [ #total of 180
      90, # Key
      90, # Value
    ]

    nested_table_measurements = pdf.make_table(measurements, column_widths: measurements_column_widths, width: measurements_column_widths.sum) do
      cells.style(:padding => 2, borders: [], size: 8)
      row(0).style(font_style: :bold, align: :center)
      column(0).borders = [:left, :top, :bottom]
      column(1).borders = [:top, :bottom, :right]
    end

    measurements_cell = pdf.make_cell(
      content: nested_table_measurements,
      borders: [:top, :bottom, :left, :right],
      padding: 0
    ) # as a single cell

    specifications = [
      [{content: "SPECIFICATION", colspan: 2}],
      [{content: "ADJUSTER TYPE"},{content: vest.adjuster_type.nil? ? "None" : vest.adjuster_type}],
      [{content: "LAPEL STYLE"},{content: vest.lapel_style.nil? ? "None" : vest.lapel_style}],
      [{content: "FABRIC"},{content: vest.fabric.nil? ? "None" : vest.fabric}],
      [{content: "FABRIC CONSUMPTION"},{content: vest.fabric_consumption.nil? ? "None" : vest.fabric_consumption}],
      [{content: "SIDE POCKET"},{content: vest.side_pocket.nil? ? "None" : vest.side_pocket}],
      [{content: "VEST MODEL"},{content: vest.vest_model.nil? ? "None" : vest.vest_model}],
    ]

    nested_table_specifications = pdf.make_table(specifications, width: 180, column_widths: [90,90]) do
      row(0).style(font_style: :bold, align: :center)
      cells.style(:padding => 2, border: [], size: 8)
    end

    specifications_cell = pdf.make_cell(
      content: nested_table_specifications,
      borders: [:top, :bottom, :left, :right],
      padding: 2,
    ) # as a single cell

    body = [
      [{content: header_cell, colspan: 3}],
			[measurements_cell, specifications_cell, {content: "REMARKS\n\n#{vest.remarks}"}],
    ]

    vest_table = pdf.make_table(body, width: overall_table_width) do
      cells.borders = [:left, :right, :top, :bottom]
      cells.style(align: :center, :padding => 0, :border_width => 2, size: 7)
      column(1).width = 180 #specs
      column(2).width = 180 #Remarks
      column(2).style(padding: 2, font_style: :bold) # Remarks
    end

    # start a new page if table will break due to remaining space
    if vest_table.height+50 > pdf.cursor
      pdf.start_new_page
    end
    vest_table.draw
  end # vest end

  @shirts.each do |shirt| # shirt start
		top_row = [
			[{content: "SHIRT"},{content: "OPENING: #{shirt.opening.nil? ? 'N/A' : shirt.opening}"}, {content: "SLEEVE LENGTH: #{shirt.sleeve_length.nil? ? 'N/A' : shirt.sleeve_length}" }],
		]

		col_num = 2 # main table column count

		header_column_widths = [50, (overall_table_width - 50) / 2.0, (overall_table_width - 50) / 2.0] # logical column width for top row

		nested_table_header = pdf.make_table(top_row, cell_style: { borders:[], padding: [2, 4, 2, 4] }, column_widths: header_column_widths) do
      cells.align = :center
      columns(0).align = :left
      columns(0).style(font_style: :bold)
    end

		header_cell = pdf.make_cell(
      content: nested_table_header,
      colspan: col_num,
      borders: [:top, :bottom, :left, :right],
      padding: 0
    ) # header outer border - as a single cell

    measurements = [
      ["SHIRT LENGTH","BACK WIDTH","CUFFS","CHEST","SHIRT WAIST","SHOULDERS"
      ],
      [{ content: shirt.shirt_length.nil? ? "N/A" : "#{shirt.shirt_length}" },
         { content: shirt.back_width.nil? ? "N/A" : "#{shirt.back_width}" },
         { content: (shirt.right_cuff.nil? && shirt.left_cuff.nil?) ? "N/A" : "R: #{shirt.right_cuff.nil? ? 'N/A' : shirt.right_cuff}\nL: #{shirt.left_cuff.nil? ? 'N/A' : shirt.left_cuff}" },
         { content: shirt.chest.nil? ? "N/A" : "#{shirt.chest}" },
         { content: shirt.shirt_waist.nil? ? "N/A" : "#{shirt.shirt_waist}" },
         { content: shirt.shoulders.nil? ? "N/A" : "#{shirt.shoulders}" },
      ],
    ]

    measurements_column_widths = [ # total of 400
      50,  # shirt_length
      50,  # back_width
      50,  # right_cuff & left_cuff
      50,  # chest
      50,  # shirt_waist
      50,  # shoulder
      50,  # blank
      50,  # blank
    ] # not in use

    nested_table_measurements = pdf.make_table(measurements, width: 400) do
      cells.align = :center
      cells.style(:padding => 2, borders: [], size: 7)
      row(0).borders = [:left, :right, :top]
      row(1).borders = [:left, :right, :bottom]
    end

    measurements_cell = pdf.make_cell(
      content: nested_table_measurements,
      colspan: col_num - 1,
      borders: [:top, :bottom, :left, :right],
      padding: 0,
    ) # as a single cell

    # images initialization
    #collar
	  case shirt.collar
		  when "Traditional"
				shirt_collar_style = "#{dir}shirt/collar/Traditional.png"
		  when "Spread"
				shirt_collar_style = "#{dir}shirt/collar/Spread.png"
		  when "Wide_(Italian)"
				shirt_collar_style = "#{dir}shirt/collar/Wide(Italian).png"
		  when "Button Down"
				shirt_collar_style = "#{dir}shirt/collar/Button_Down.png"
		  when "Hidden Button Down"
				shirt_collar_style = "#{dir}shirt/collar/Hidden_Button_Down.png"
		  when "Wing"
				shirt_collar_style = "#{dir}shirt/collar/Wing.png"
		  when "Chinese"
				shirt_collar_style = "#{dir}shirt/collar/Chinese.png"
		  when "Semi-spread"
				shirt_collar_style = "#{dir}shirt/collar/Semi-spread.png"
		  when "Nehru"
				shirt_collar_style = "#{dir}shirt/collar/Nehru.png"
	    else
				shirt_collar_style = "#{dir}x.png"
	  end

    #sleeves
    case shirt.sleeves
      when /^Contrast 1/
        shirt_sleeves_style = "#{dir}shirt/contrast/Contrast_1.png"
      when /^Contrast 2/
        shirt_sleeves_style = "#{dir}shirt/contrast/Contrast_2.png"
      when /^Contrast 3/
        shirt_sleeves_style = "#{dir}shirt/contrast/Contrast_3.png"
      else
        shirt_sleeves_style = "#{dir}x.png"
    end

    #cuffs
    case shirt.cuffs
      when "Single_1-button_curve", "Single_1-button_round"
        shirt_cuffs_style = "#{dir}shirt/cuffs/Single1_button_curve.png"
      when "Single_1-button_angle"
				shirt_cuffs_style = "#{dir}shirt/cuffs/Single1_button_angled.png"
      when "Single_1-button_square"
				shirt_cuffs_style = "#{dir}shirt/cuffs/single1_button_square.png"
      when "Double_French_square"
				shirt_cuffs_style = "#{dir}shirt/cuffs/Double_French_square.png"
      when "Double_French_angled"
				shirt_cuffs_style = "#{dir}shirt/cuffs/Double_French_angled.png"
      when "Double_French_curve"
				shirt_cuffs_style = "#{dir}shirt/cuffs/Double_French_curve.png"
      else
				shirt_cuffs_style = "#{dir}x.png"
    end

    #pocket
    case shirt.pocket
      when "Round"
        shirt_pocket_style = "#{dir}shirt/pocket/Round_Pocket.png"
      #when "Agile"
        #shirt_pocket_style = "#{dir}shirt/pocket/Agile_Pocket.png"
      when "Pointed"
        shirt_pocket_style = "#{dir}shirt/pocket/Pointed_Pocket.png"
      when "Square w/ Pleats"
        shirt_pocket_style = "#{dir}shirt/pocket/Square_wPleat_Pocket.png"
      when "Wine glass"
        shirt_pocket_style = "#{dir}shirt/pocket/Wine_Glass_Pocket.png"
      when "Square", "Agile"
        shirt_pocket_style = "#{dir}shirt/pocket/Square_Pocket.png"
      else
        shirt_pocket_style = "#{dir}x.png"
    end

    shirt_images = [
      [{image: shirt_collar_style, fit:[60,60]},
        {image: shirt_sleeves_style, fit:[60,60]},
        {image: shirt_cuffs_style, fit:[60,60]},
        {image: shirt_pocket_style, fit:[60,60]},
      ],
      [{content: "#{shirt.collar}\nCOLLAR"},
        {content: "#{shirt.sleeves}\nSLEEVES"},
        {content: "#{shirt.cuffs}\nCUFFS"},
        {content: "#{shirt.pocket}\nPOCKET"},
      ],
    ]
		images_col_num = 4
		column0_table_width = 400
    column_width = column0_table_width / images_col_num

	  nested_table_shirt_images = pdf.make_table(shirt_images, width: column0_table_width, column_widths: [column_width]*images_col_num ) do
      cells.position = :center
      cells.align = :center
      cells.style(:padding => 4, borders: [], size: 8)
    end

    shirt_images_cell = pdf.make_cell(
      content: nested_table_shirt_images,
      colspan: col_num - 1,
      borders: [:top, :bottom, :left, :right],
      padding: 2,
    ) # outer border - treated as single cell in master table

    #specs initialization
    shirt_front_pleats = (shirt.front_pleats.to_s.empty? ? "N/A" : shirt.front_pleats)
    shirt_back_pleats = (shirt.back_pleats.to_s.empty? ? "N/A" : shirt.back_pleats)
    shirt_front_pocket_flap = (shirt.front_pocket_flap.to_s.empty? ? "N/A" : shirt.front_pocket_flap)
    shirt_bottom = (shirt.bottom.to_s.empty? ? "N/A" : shirt.bottom)
    shirt_monogram_placement = (shirt.monogram_placement.to_s.empty? ? "N/A" : shirt.monogram_placement)
    shirt_fabric_consumption = (shirt.fabric_consumption.to_s.empty? ? "N/A" : shirt.fabric_consumption)

    shirt_remarksAndSpecs = [
      [{content: "REMARKS\n\n#{shirt.remarks}"}],
      [{content: "FRONT PLEATS: #{shirt_front_pleats}\nBACK PLEATS: #{shirt_back_pleats}\nFRONT POCKET FLAP: #{shirt_front_pocket_flap}\nBOTTOM: #{shirt_bottom}\nMONOGRAM PLACEMENT: #{shirt_monogram_placement}\nFABRIC CONSUMPTION: #{shirt_fabric_consumption}"}]
    ]

    nested_table_shirt_remarksAndSpecs = pdf.make_table(shirt_remarksAndSpecs, width: 140) do
      cells.position = :center
      cells.align = :center
      cells.style(padding: [5,2,5,3], size: 7)

      row(0).style(font_style: :bold)
      row(1).align = :left
      row(1).borders = [:top]
    end

    shirt_remarksAndSpecs_cell = pdf.make_cell(
      content: nested_table_shirt_remarksAndSpecs,
      rowspan: 2,
      padding: 0,
    ) # outer border - treated as single cell in master table

		body = [
			[header_cell],
			[measurements_cell,shirt_remarksAndSpecs_cell],
			[shirt_images_cell],
		]

		shirt_table = pdf.make_table(body, width: overall_table_width) do
      cells.borders = [:left, :right, :top, :bottom]
      cells.style(align: :center, :padding => 0, :border_width => 2, size: 7)

      row(0).style(size: 8)
      column(0).width = 400 #nested tables
      column(1).width = 140 #remarks
      row(1).column(0).borders = [:left, :right, :top]
      row(2).column(0).borders = [:left, :right, :bottom]
    end

		# start a new page if table will break due to remaining space
    if shirt_table.height+50 > pdf.cursor
      pdf.start_new_page
    end
    shirt_table.draw
  end # shirt end

  # Body End ############################
end # Prawn END
