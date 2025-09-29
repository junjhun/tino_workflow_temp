ActiveAdmin.register Order do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :name, :status, :purpose, :type_of_service, :first_fitting, :second_fitting, :third_fitting, :event_date, :finish, :jo_number, :brand_name, :rush, :item_type,
                items_attributes: %i[id name quantity fabric_and_linning_code _destroy],
                vests_attributes: %i[id quantity fabric_code lining_code fabric_consumption vest_length back_width chest waist hips vest_style lapel_style lapel_width fabric adjuster_type chest_pocket side_pocket remarks _destroy],
                shirts_attributes: %i[id quantity fabric_code lining_code fabric_consumption shirt_length back_width right_cuff left_cuff chest shirt_waist stature shoulders opening front_placket no_of_studs front_pleats sleeve back_pleats pocket with_flap front_pocket_flap sleeve_length cuffs collar collar_style buttoned_down buttoned_down_with_loop traditional_collar_type bottom sleeves contrast_placement monogram_initials monogram_placement hips monogram_font monogram_color remarks _destroy],
                coats_attributes: %i[id quantity fabric_code lining_code  fabric_consumption jacket_length back_width sleeves cuffs_1 cuffs_2 collar chest waist stature shoulders style lapel_style lapel_satin lapel_width hips vent sleeves_and_padding lining sleeve_buttons button_spacing button no_of_buttons color_of_sleeve_buttons boutonniere flower_holder lapel_buttonhole_thread_color pocket_type chest_pocket_satin front_side_pocket side_pockets_flap side_pockets_satin side_pockets_ticket side_pocket_placement monogram_initials monogram_placement monogram_font monogram_thread_color remarks _destroy],
                pants_attributes: %i[id quantity fabric_code lining_code fabric_consumption crotch outseam waist seat thigh knee bottom rise cut pleats_combined strap waistband_thickness waist_area closure crotch_saddle type_of_pocket front_pocket coin_pocket flap_on_coin_pocket back_pocket flap_on_jetted_pocket buttons_on_jetted_pockets button_loops_on_jetted_pockets add_suspender_buttons satin_trim cuff_on_hem width_of_cuff remarks _destroy]                

  show title: proc { |order| "Order ##{order.jo_number} - #{order.client.name}" }     

  config.per_page = [10, 20, 50]
  config.batch_actions = false 


  scope :all, default: true do |orders|
    orders
  end
  
  scope :'Tiño' do |orders|
    orders.where(brand_name: '0')
  end
  
  scope :'Olpiana Andres' do |orders|
    orders.where(brand_name: '1')
  end
  
  scope :'St. James' do |orders|
    orders.where(brand_name: '2')
  end

  scope :'Has Pants' do |orders|
    orders.joins(:pants).distinct
  end

  scope :'Has Coat' do |orders|
    orders.joins(:coats).distinct
  end

  scope :'Has Vest' do |orders|
    orders.joins(:vests).distinct
  end

  scope :'Has Shirt' do |orders|
    orders.joins(:shirts).distinct
  end

  
  index do
    column 'Job Order', sortable: :jo_number do |order|
      link_to "##{order.jo_number}", admin_order_path(order)
    end
    column :client do |order|
      link_to order.client.name, admin_client_path(order.client)
    end
    column :"Order Type" do |order|
      order_type = []
      order_type << 'Coat' if order.coats.any?
      order_type << 'Vest' if order.vests.any?
      order_type << 'Shirt' if order.shirts.any?
      order_type << 'Pants' if order.pants.any?
      order_type.join(', ')
    end
    column :"Status", :status_label, sortable: :status
    column :"Brand", :brand_name
    column :"Service type", :type_of_service
    # humanize to remove underscore
    column :purpose do |order|
      order.purpose.nil? || order.purpose.empty? ? 'None' : order.purpose.humanize
    end
    column :created_at do |order|
      order.created_at.strftime('%B %d %Y')
    end
    column :finish
    # actions

  end

  
  # Make client column sortable
  controller do
    def scoped_collection
      super.includes :client
    end

    def create
      # Call the default Active Admin create method first
      super do |format|
        if resource.persisted? # If the resource was successfully saved
          flash[:notice] = "Order was successfully created."
          redirect_to admin_order_path(resource) and return
        else
          # If save failed, resource.errors will contain the validation messages
          Rails.logger.debug "Order errors: #{resource.errors.full_messages}"
          # Render the new form again with errors shown by Active Admin
          flash.now[:error] = "Order could not be created. Please check the form for errors."
        end
      end
    end

    def scoped_collection
      super.includes(:client)

      if params[:q] && params[:q][:fitting_dates].present?
        dates = params[:q][:fitting_dates]
        # Handle potential errors or invalid date formats
        begin
          dates = dates.map { |date_str| Date.parse(date_str) }
        rescue ArgumentError
          # Handle invalid date format
        end
        where('first_fitting IN (?) OR second_fitting IN (?)', dates, dates)
      else
        super
      end
    end
  end

  collection_action :approve, method: :post do
    # Do some CSV importing work here...
    id = params[:format].to_i
    order = Order.find(id)
    status = order.status

    new_status = case status
                 when 'Client Appointment'
                   "JO's to receive by the PRODUCTION MANAGER (LAS PIÑAS)"
                 when "JO's to receive by the PRODUCTION MANAGER (LAS PIÑAS)"
                   'PRODUCTION MANAGER to handover the following to the MASTER TAILOR (LAS PIÑAS)'
                 when 'PRODUCTION MANAGER to handover the following to the MASTER TAILOR (LAS PIÑAS)'
                   'MASTER TO TAILOR TO HAND OVER THE ROLLED FABRIC AND PATTERN WITH JO TO THE PROD MANAGER (LAS PIÑAS)'
                 when 'MASTER TO TAILOR TO HAND OVER THE ROLLED FABRIC AND PATTERN WITH JO TO THE PROD MANAGER (LAS PIÑAS)'
                   'PRODUCTION MANAGER TO DISTRIBUTE TO MANANAHI TO ASSEMBLE THE PRODUCT FOR 1ST FITTING'
                 when 'PRODUCTION MANAGER TO DISTRIBUTE TO MANANAHI TO ASSEMBLE THE PRODUCT FOR 1ST FITTING'
                   "ONCE DONE, THE PRODUCT WILL BE DELIVERED TO STORE IN MAKATI FOR CLIENT'S FIRST FITTING"
                 when "ONCE DONE, THE PRODUCT WILL BE DELIVERED TO STORE IN MAKATI FOR CLIENT'S FIRST FITTING"
                   'GIVE THE FITTING GARMENT TO MASTER TAILOR AND PATTERN FOR AREGLO IN PREPS FOR 2ND FITTING'
                 else
                   'DONE'
                 end

    order.update(status: new_status)
    redirect_to collection_path, notice: "Order from #{order.name} has been updated to #{new_status}"
  end

  form do |f|
    #go back button
    div class: 'back-button' do
      link_to '← Back', admin_orders_path
    end

    f.semantic_errors

    f.inputs do
      f.input :status, disabled: f.object.persisted?
      # f.input :client_id, input_html: { value: client.name, disabled: true }
      # f.input :client, as: :select, collection: Client.all.map { |c| [c.name, c.id] }, disabled: f.object.persisted?

			f.input :client_id, as: :select,
							collection: Client.all.map { |c| [c.name, c.id] },
              selected: f.object.persisted? ? f.object.client_id : params[:client_id],
							disabled: f.object.persisted?

			f.input :purpose
      f.input :brand_name, as: :select, collection: Order.brand_names.keys
      f.input :type_of_service, label: 'Type of Service'
      f.input :rush, as: :boolean, label: 'Rush Order', input_html: { id: 'rush-checkbox' }
      f.input :first_fitting, as: :datepicker, input_html: { id: 'first_fitting', class: 'datepicker' }
      f.input :second_fitting,as: :datepicker, input_html: { id: 'second_fitting', class: 'datepicker' }
      f.input :third_fitting, as: :datepicker,input_html: { id: 'third_fitting', class: 'datepicker' }
      f.input :finish, as: :datepicker, input_html: { id: 'finish', class: 'datepicker' }
      f.input :event_date, as: :datepicker, input_html: { id: 'event_date', class: 'datepicker' }
      f.input :jo_number
    end

    tabs do
      tab 'Coats' do
        # Content for the Coat section
        f.inputs 'Coats', id: 'coats-section' do
          f.has_many :coats, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_code
            t.input :lining_code
            t.input :fabric_consumption
            t.input :jacket_length
            t.input :back_width
            t.input :sleeves
            t.input :cuffs_1, label: 'Right cuff'
            t.input :cuffs_2, label: 'Left cuff'
            t.input :collar
            t.input :chest
            t.input :waist
            t.input :hips
            t.input :stature
            t.input :shoulders           
            t.input :style, label: "Model"
            t.input :lapel_style
            t.input :lapel_satin, as: :boolean, label: 'With satin'
            t.input :lapel_width
            t.input :vent
            t.input :sleeves_and_padding, label: 'Shoulder padding'
            t.input :lining
            t.input :sleeve_buttons, label: 'Sleeve button function'
            # (Not applicable when sleeve button function is none)
            t.input :button_spacing, label: 'Sleeve button spacing'
            # (Not applicable when sleeve button function is none)
            t.input :button, label: 'Type of sleeve button'
            # (Not applicable when sleeve button function is none)
            t.input :no_of_buttons, label: 'No. of  sleeve buttons'
            # (Not applicable when sleeve button function is none)
            t.input :color_of_sleeve_buttons
            t.input :boutonniere, label: 'Lapel buttonhole' 
            # Not applicable for none lapel buttonhole option
            t.input :flower_holder, as: :boolean, label: 'With flower holder'
            t.input :lapel_buttonhole_thread_color
            t.input :pocket_type, label: 'Chest pocket'
            t.input :chest_pocket_satin, as: :boolean, label: 'With satin'
            t.input :front_side_pocket, label: 'Side pockets'
            t.input :side_pockets_flap, as: :boolean, label: 'With flap'
            # (Not applicable for patch chest pocket option and no chest pocket option)
            t.input :side_pockets_satin, as: :boolean, label: 'With Satin'
            t.input :side_pockets_ticket, as: :boolean, label: 'With ticket pocket'
            t.input :side_pocket_placement, label: 'Side pocket placement'

            # Monogram Fields
            t.input :monogram_initials, input_html: { class: 'monogram-initials-input' }
            t.input :monogram_placement, as: :select, collection: Coat.monogram_placements.keys.map { |m| [m.humanize, m] }, include_blank: true, input_html: { class: 'monogram-placement-input', disabled: true }
            t.input :monogram_font, as: :select, collection: Coat.monogram_fonts.keys.map { |m| [m.humanize, m] }, include_blank: true, input_html: { class: 'monogram-font-input', disabled: true  }
            t.input :monogram_thread_color

            t.input :remarks
          end
        end
      end

      tab 'Pants' do
        f.inputs 'Pants', id: 'pants-section' do
          f.has_many :pants, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_code
            t.input :lining_code
            t.input :fabric_consumption
            t.input :crotch
            t.input :outseam
            t.input :waist
            t.input :seat
            t.input :thigh
            t.input :knee
            t.input :bottom
            t.input :rise
            t.input :cut
            t.input :pleats_combined, label: 'Pleats'
            t.input :strap, label: 'Overlap'
            t.input :waistband_thickness
            t.input :waist_area, label: 'Tightening'
            t.input :closure
            t.input :crotch_saddle, as: :boolean
            t.input :type_of_pocket, label: 'Front Pocket'
            t.input :coin_pocket, as: :boolean
            t.input :flap_on_coin_pocket, as: :boolean
            t.input :back_pocket
            t.input :flap_on_jetted_pocket, as: :boolean
            t.input :buttons_on_jetted_pockets, as: :boolean
            t.input :button_loops_on_jetted_pockets, as: :boolean
            t.input :add_suspender_buttons, as: :boolean
            t.input :satin_trim, as: :boolean
            t.input :cuff_on_hem, as: :boolean
            t.input :width_of_cuff
            t.input :remarks
          end
        end
      end
    
      tab 'Vests' do
        f.inputs 'Vests', id: 'vests-section' do
          f.has_many :vests, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_code
            t.input :lining_code
            t.input :fabric_consumption
            t.input :vest_length
            t.input :back_width
            t.input :chest
            t.input :waist
            t.input :hips
            t.input :vest_style, label: 'Vest model'
            t.input :lapel_style
            t.input :lapel_width
            t.input :fabric
            t.input :adjuster_type
            t.input :chest_pocket
            t.input :side_pocket
            t.input :remarks
          end
        end
      end

      tab 'Shirts' do
        f.inputs 'Shirts', id: 'shirts-section' do
          f.has_many :shirts, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_code
            t.input :lining_code
            t.input :fabric_consumption
            t.input :shirt_length
            t.input :back_width
            t.input :sleeve
            t.input :right_cuff
            t.input :left_cuff
            t.input :collar
            t.input :chest
            t.input :shirt_waist
            t.input :hips
            t.input :stature
            t.input :shoulders
            t.input :opening
            t.input :front_placket, label: 'Front bar'
            t.input :no_of_studs
            t.input :front_pleats
            t.input :back_pleats
            t.input :pocket, label: 'Front pocket'
            t.input :with_flap, as: :boolean
            t.input :front_pocket_flap
            t.input :sleeve_length
            t.input :cuffs
            t.input :collar_style
            t.input :buttoned_down, as: :boolean
            t.input :buttoned_down_with_loop, as: :boolean
            t.input :bottom, label: 'Hem'
            t.input :sleeves, label: 'Contrast'
            t.input :contrast_placement

            # Monogram Fields
            t.input :monogram_initials, input_html: { class: 'monogram-initials-input' }
            t.input :monogram_placement, as: :select, collection: Shirt.monogram_placements.keys.map { |m| [m.humanize, m] }, include_blank: true, input_html: { class: 'monogram-placement-input', disabled: true }
            t.input :monogram_font, as: :select, collection: Shirt.monogram_fonts.keys.map { |m| [m.humanize, m] }, include_blank: true, input_html: { class: 'monogram-font-input', disabled: true  }
            t.input :monogram_color

            t.input :remarks
          end
        end
      end
    end
    f.actions
  end
  
  show do
    # Go back button
    div class: 'back-button' do
      link_to '← Back', admin_orders_path
    end

    columns do
      column do
        # Use this clean version with the class on the panel
        panel 'Information', class: 'client_info_panel' do
          attributes_table_for order do
            row :jo_number
            row :client
            row :status
            row :purpose do |order|
              order.purpose.nil? || order.purpose.empty? ? 'None' : order.purpose.humanize
            end
            row :type_of_service
            row :brand_name
          end
        end
      end

      column do
        panel 'Date Details', class: 'date_details_panel' do
          attributes_table_for order do
            row("Date Created") { order.created_at.strftime('%B %d %Y') }
            row :first_fitting
            row :second_fitting
            row :third_fitting
            row :event_date
            row :finish
          end
        end
      end
    end

    columns do
      panel 'Stature', class: 'stature_panel' do
        attributes_table_for order do
          if order.coats.any?
            row :stature do |order|
              order.coats.first.stature
            end
            row :shoulders do |order|
              order.coats.first.shoulders
            end
          elsif order.shirts.any?
            row :stature do |order|
              order.shirts.first.stature
            end
            row :shoulders do |order|
              order.shirts.first.shoulders
            end
          end
        end
      end
    end

  # Start of Tabs
  tabs do

    # start of coat tab
    if order.coats.any?
      tab 'Coat' do
        # --- Dropdown Switcher (only shows if there is more than one coat) ---
        if order.coats.size > 1
          div style: "margin-bottom: 20px;" do
            label 'Select Coat to View:', for: 'coat-switcher', style: "display: block; margin-bottom: 5px; font-weight: bold;"
            select id: 'coat-switcher' do
              order.coats.each_with_index do |coat, index|
                option value: index do
                  "Coat ##{index + 1}"
                end
              end
            end
          end
        end

        # --- Coat Content Panels (one for each coat) ---
        order.coats.each_with_index do |coat, index|
          div id: "coat-content-#{index}", class: 'coat-content' do
            if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Coat Maker'])

              # --- Panel 1: Measurements ---
              measurements = {
                "Jacket Length" => coat.jacket_length,
                "Back Width" => coat.back_width,
                "Sleeves" => coat.sleeves,
                "Right Cuff" => coat.cuffs_1,
                "Left Cuff" => coat.cuffs_2,
                "Collar" => coat.collar,
                "Chest" => coat.chest,
                "Waist" => coat.waist,
                "Hips" => coat.hips
              }
              responsive_attributes_panel("Coat Measurements", measurements)

              # --- Panel 2: Specifications ---
              specifications = {
                "Quantity" => coat.quantity,
                "Fabric Code" => coat.fabric_code,
                "Lining Code" => coat.lining_code,
                "Fabric Consumption" => coat.fabric_consumption,
                "Lapel Width" => coat.lapel_width,
                "Sleeve Button Function" => coat.sleeve_buttons,
                "Type of Sleeve Button" => coat.button,
                "No. of Sleeve Buttons" => coat.no_of_buttons,
                "Color of Sleeve Buttons" => coat.color_of_sleeve_buttons,
                "Lapel Buttonhole Thread Color" => coat.lapel_buttonhole_thread_color,
                "Side Pocket Placement" => coat.side_pocket_placement,
                "Monogram Initials" => coat.monogram_initials,
                "Monogram Font" => coat.monogram_font,
                "Monogram Thread Color" => coat.monogram_thread_color,
                "Lapel With Satin" => coat.lapel_satin?,
                "With Flower Holder" => coat.flower_holder?,
                "Chest Pocket With Satin" => coat.chest_pocket_satin?,
                "Side Pockets With Flap" => coat.side_pockets_flap?,
                "Side Pockets With Satin" => coat.side_pockets_satin?,
                "With Ticket Pocket" => coat.side_pockets_ticket?,
                "Remarks" => coat.remarks
              }
              responsive_attributes_panel("Coat Specifications", specifications)

              # --- Panel 3: Style Images ---
              panel 'Coat Style Images' do
                div class: 'responsive-images-panel' do
                  div class: 'responsive-images-container' do
                    responsive_image_item(coat, :style, :coat_style_image_asset_path, "Model")
                    responsive_image_item(coat, :lapel_style, :coat_lapel_style_image_asset_path, "Lapel Style")
                    responsive_image_item(coat, :vent, :coat_vent_image_asset_path, "Vent")
                    responsive_image_item(coat, :sleeves_and_padding, :coat_shoulder_padding_image_asset_path, "Shoulder Padding")
                    responsive_image_item(coat, :lining, :coat_lining_image_asset_path, "Lining")
                    responsive_image_item(coat, :button_spacing, :coat_button_spacing_image_asset_path, "Sleeve Button Spacing")
                    responsive_image_item(coat, :boutonniere, :coat_boutonniere_image_asset_path, "Lapel Buttonhole")
                    responsive_image_item(coat, :pocket_type, :coat_chest_pocket_image_asset_path, "Chest Pocket")
                    responsive_image_item(coat, :front_side_pocket, :coat_side_pocket_image_asset_path, "Side Pockets")
                  end
                end
              end
            end
          end
        end
      end
    end

    # start of pants tab
    if order.pants.any?
      tab 'Pants' do
        # --- Dropdown Switcher (only shows if there is more than one pant) ---
        if order.pants.size > 1
          div style: "margin-bottom: 20px;" do
            label 'Select Pant to View:', for: 'pant-switcher', style: "display: block; margin-bottom: 5px; font-weight: bold;"
            select id: 'pant-switcher' do
              order.pants.each_with_index do |pant, index|
                option value: index do
                  "Pant ##{index + 1}"
                end
              end
            end
          end
        end

        # --- Pant Content Panels (one for each pant) ---
        order.pants.each_with_index do |pant, index|
          div id: "pant-content-#{index}", class: 'pant-content' do
            if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Pants Maker'])

              # --- Panel 1: Measurements ---
              measurements = {
                "Outseam" => pant.outseam,
                "Waist" => pant.waist,
                "Seat" => pant.seat,
                "Thigh" => pant.thigh,
                "Knee" => pant.knee,
                "Bottom" => pant.bottom
              }
              responsive_attributes_panel("Pant Measurements", measurements)

              # --- Panel 2: Specifications ---
              specifications = {
                "Quantity" => pant.quantity,
                "Fabric Code" => pant.fabric_code,
                "Lining Code" => pant.lining_code,
                "Fabric Consumption" => pant.fabric_consumption,
                "Pleats" => pant.pleats_combined,
                "Overlap" => pant.strap,
                "Tightening" => pant.waist_area,
                "Crotch Saddle" => pant.crotch_saddle?,
                "Coin Pocket" => pant.coin_pocket?,
                "Flap on Coin Pocket" => pant.flap_on_coin_pocket?,
                "Flap on Jetted Pocket" => pant.flap_on_jetted_pocket?,
                "Buttons on Jetted Pockets" => pant.buttons_on_jetted_pockets?,
                "Button Loops on Jetted Pockets" => pant.button_loops_on_jetted_pockets?,
                "Add Suspender Buttons" => pant.add_suspender_buttons?,
                "Satin Trim" => pant.satin_trim?,
                "Cuff on Hem" => pant.cuff_on_hem?,
                "Width of Cuff" => pant.width_of_cuff,
                "Remarks" => pant.remarks
              }
              responsive_attributes_panel("Pant Specifications", specifications)
            end
          end
        end
      end
    end

    # start of vest tab
    if order.pants.any?
      tab 'Vests' do
        # --- Dropdown Switcher (only shows if there is more than one vest) ---
        if order.vests.size > 1
          div style: "margin-bottom: 20px;" do
            label 'Select Vest to View:', for: 'vest-switcher', style: "display: block; margin-bottom: 5px; font-weight: bold;"
            select id: 'vest-switcher' do
              order.vests.each_with_index do |vest, index|
                option value: index do
                  "Vest ##{index + 1}"
                end
              end
            end
          end

          # --- Vest Content Panels (one for each vest) ---
          order.vests.each_with_index do |vest, index|
            div id: "vest-content-#{index}", class: 'vest-content' do
              if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Vest Maker'])

                # --- Panel 1: Measurements ---
                measurements = {
                  "Vest Length" => vest.vest_length,
                  "Back Width" => vest.back_width,
                  "Chest" => vest.chest,
                  "Vest Waist" => vest.waist,
                  "Hips" => vest.hips
                }
                responsive_attributes_panel("Vest Measurements", measurements)

                # --- Panel 2: Specifications ---
                specifications = {
                  "Quantity" => vest.quantity,
                  "Fabric Code" => vest.fabric_code,
                  "Lining Code" => vest.lining_code,
                  "Fabric Consumption" => vest.fabric_consumption,
                  "Vest Model" => vest.vest_style,
                  "Lapel Style" => vest.lapel_style,
                  "Lapel Width" => vest.lapel_width,
                  "Fabric" => vest.fabric,
                  "Adjuster Type" => vest.adjuster_type,
                  "Chest Pocket" => vest.chest_pocket,
                  "Side Pocket" => vest.side_pocket,
                  "Remarks" => vest.remarks
                }
                responsive_attributes_panel("Vest Specifications", specifications)
              end
            end
          end
        end
      end
    end

    # start of shirt tab
    if order.shirts.any?
      tab 'Shirt' do
        # --- Dropdown Switcher (only shows if there is more than one shirt) ---
        if order.shirts.size > 1
          div style: "margin-bottom: 20px;" do
            label 'Select Shirt to View:', for: 'shirt-switcher', style: "display: block; margin-bottom: 5px; font-weight: bold;"
            select id: 'shirt-switcher' do
              order.shirts.each_with_index do |shirt, index|
                option value: index do
                  "Shirt ##{index + 1}"
                end
              end
            end
          end

          # --- Shirt Content Panels (one for each shirt) ---
          order.shirts.each_with_index do |shirt, index|
            div id: "shirt-content-#{index}", class: 'shirt-content' do
              if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Shirt Maker'])

                # --- Panel 1: Measurements ---
                measurements = {
                  "Shirt Length" => shirt.shirt_length,
                  "Back Width" => shirt.back_width,
                  "Sleeve" => shirt.sleeve,
                  "Right Cuff" => shirt.right_cuff,
                  "Left Cuff" => shirt.left_cuff,
                  "Collar" => shirt.collar,
                  "Chest" => shirt.chest,
                  "Shirt Waist" => shirt.shirt_waist,
                  "Hips" => shirt.hips
                }
                responsive_attributes_panel("Shirt Measurements", measurements)

                # --- Panel 2: Specifications ---
                specifications = {
                  "Quantity" => shirt.quantity,
                  "Fabric Code" => shirt.fabric_code,
                  "Lining Code" => shirt.lining_code,
                  "Fabric Consumption" => shirt.fabric_consumption,
                  "Opening" => shirt.opening,
                  "No. of Studs" => shirt.no_of_studs,
                  "Front Bar" => shirt.front_placket,
                  "Front Pocket" => shirt.pocket,
                  "With Flap" => shirt.with_flap?,
                  "Cuffs" => shirt.cuffs,
                  "Collar Style" => shirt.collar_style,
                  "Buttoned Down" => shirt.buttoned_down?,
                  "Buttoned Down with Loop" => shirt.buttoned_down_with_loop?,
                  "Hem" => shirt.bottom,
                  "Contrast" => shirt.sleeves,
                  "Contrast Placement" => shirt.contrast_placement,
                  "Monogram Initials" => shirt.monogram_initials,
                  "Monogram Font" => shirt.monogram_font,
                  "Monogram Color" => shirt.monogram_color,
                  "Monogram Placement" => shirt.monogram_placement,
                  "Remarks" => shirt.remarks
                }
                responsive_attributes_panel("Shirt Specifications", specifications)

                # --- Panel 3: Style Images ---
                panel 'Shirt Style Images' do
                  div class: 'responsive-images-panel' do
                    div class: 'responsive-images-container' do
                      responsive_image_item(shirt, :pocket, :pocket_image_asset_path, "Front Pocket")
                      responsive_image_item(shirt, :cuffs, :cuffs_image_asset_path, "Cuffs")
                      responsive_image_item(shirt, :collar_style, :collar_style_image_asset_path, "Collar Style")
                      responsive_image_item(shirt, :sleeves, :sleeves_image_asset_path, "Contrast")
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  panel 'Version History', class: 'version_history_panel' do
    table_for order.versions do
      column 'Event' do |version|
        version.event
      end
      column 'Modified At' do |version|
        version.created_at.strftime('%B %d %Y %H:%M:%S')
      end
      column 'Modified By' do |version|
        User.find(version.whodunnit).name if version.whodunnit
      end
      column 'Changes' do |version|
        version.changeset.map { |k, v| "#{k}: #{v[0]} -> #{v[1]}" }.join(", ").html_safe if version.changeset.present?
      end
    end
  end

  active_admin_comments
end

  action_item :view, only: :show do
    if order.status != 'DONE'
      link_to 'Approve', approve_admin_orders_path(order), method: :post, class: 'green-button'
    end
  end

  controller do
    before_action :restrict_new_order_for_makers, only: :new
    before_action :restrict_actions_for_makers, only: %i[edit destroy approve]

    private

    def restrict_actions_for_makers
      if current_user.role.in?(['Coat Maker', 'Pants Maker', 'Shirt Maker', 'Vest Maker', 'Production Manager'])
        redirect_to admin_orders_path, alert: 'You are not authorized to perform this action.'
      end
    end

    def restrict_new_order_for_makers
      if current_user.role.in?(['Coat Maker', 'Pants Maker', 'Shirt Maker', 'Vest Maker', 'Production Manager'])
        redirect_to admin_orders_path, alert: 'You are not authorized to create new orders.'
      end
    end
  end

  action_item :print_options, only: :show do
    link_to "<i class='fa fa-print'></i> Print".html_safe, reports_order_path(order, type: 'Master'), target: '_blank'
  end

  # Filter side bar
  filter :client_name, as: :select, label: 'Client Name', collection: Client.all.map { |order| order.name }
  filter :type_of_service, as: :select, label: 'Type of Service', collection: Order.type_of_services.keys
  filter :jo_number, as: :select, label: 'Job Order #', collection: proc { Order.distinct.pluck(:jo_number) } 
  filter :purpose, as: :select, collection: Order.distinct.pluck(:purpose)
  filter :created_at, as: :date_range
  
  filter :created_at
end

