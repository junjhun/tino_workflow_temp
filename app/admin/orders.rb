ActiveAdmin.register Order do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :name, :status, :purpose, :type_of_service, :first_fitting, :second_fitting, :third_fitting, :fourth_fitting, :event_date, :finish, :jo_number, :brand_name, :rush, :item_type,
                items_attributes: %i[id name quantity fabric_and_linning_code _destroy],
                vests_attributes: %i[id quantity fabric_code lining_code fabric_consumption chest_pocket vest_length back_width
                  chest waist hips vest_model lapel_style lapel_width fabric adjuster_type side_pocket remarks _destroy],
                shirts_attributes: %i[id quantity fabric_code lining_code fabric_consumption shirt_length back_width sleeves
                  right_cuff left_cuff chest shirt_waist stature shoulders opening front_bar no_of_studs front_pleats back_pleats
                  front_pocket sleeves type_of_pocket with_flap front_pocket_flap sleeve_length cuffs collar buttoned_down buttoned_down_with_loop hem
                  bottom contrast contrast_placement monogram_initials monogram_placement monogram_font monogram_color specs_form
                  number_of_buttons shirting_barong fabric_label remarks control_no _destroy],
                coats_attributes: %i[id fabric_consumption specs_form fabric_label no_of_buttons breast quantity coat_no
                  jacket_length back_width sleeves cuffs_1 cuffs_2 collar chest waist hips stature shoulders remarks fabric_code
                  lining_code style lapel_style vent lining sleeves_and_padding button sleeve_buttons boutonniere boutonniere_color
                  boutonniere_thread_code button_spacing coat_pockets vent control_no pocket_type front_side_pocket _destroy],
                pants_attributes: %i[id quantity fabric_code lining_code fabric_consumption crotch outseam waist seat thigh knee
                  bottom rise cut pleats overlap waistband_thickness waist_area tightening closure crotch_saddle front_pocket coin_pocket
                  flap_on_coin_pocket back_pocket flap_on_jetted_pocket buttons_on_jetted_pockets button_loops_on_jetted_pockets
                  add_suspender_buttons satin_trim cuff_on_hem width_of_cuff remarks _destroy]
                  
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

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
      order.purpose.humanize
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
      
      f.input :client_id, as: :select, collection: Client.all.map { |c| [c.name, c.id] },
                          disabled: f.object.persisted?

      f.input :purpose
      f.input :brand_name, as: :select, collection: Order.brand_names.keys
      f.input :type_of_service, label: 'Type of Service'
      f.input :rush, as: :boolean, label: 'Rush Order', input_html: { id: 'rush-checkbox' }
      f.input :first_fitting, as: :datepicker, input_html: { id: 'first_fitting', class: 'datepicker' }
      f.input :second_fitting,as: :datepicker, input_html: { id: 'second_fitting', class: 'datepicker' }
      f.input :third_fitting, as: :datepicker,input_html: { id: 'third_fitting', class: 'datepicker' }
      f.input :event_date, as: :datepicker, input_html: { id: 'event_date', class: 'datepicker' }
      f.input :finish, as: :datepicker, input_html: { id: 'finish', class: 'datepicker' }
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
            t.input :cuffs_1, label: 'Right Cuff'
            t.input :cuffs_2, label: 'Left Cuff'
            t.input :collar
            t.input :chest
            t.input :waist
            t.input :stature
            t.input :shoulders           
            t.input :style, label: "Model"
            t.input :lapel_style
            t.input :lapel_satin, as: :boolean, label: 'With Satin'
            t.input :lapel_width
            t.input :vent
            t.input :sleeves_and_padding, label: 'Shoulder Padding'
            t.input :lining
            t.input :sleeve_buttons, label: 'Sleeve Button Function'
            # (Not applicable when sleeve button function is none)
            t.input :button_spacing, label: 'Sleeve Button Spacing'
            # (Not applicable when sleeve button function is none)
            t.input :button, label: 'Type of Sleeve Button'
            # (Not applicable when sleeve button function is none)
            t.input :no_of_buttons, label: 'No. of  Sleeve Buttons'
            # (Not applicable when sleeve button function is none)
            t.input :color_of_sleeve_buttons
            t.input :boutonniere, label: 'Lapel Buttonhole' 
            # Not applicable for none lapel buttonhole option
            t.input :flower_holder, as: :boolean, label: 'With Flower Holder'
            t.input :lapel_buttonhole_thread_color
            t.input :pocket_type, label: 'Chest Pocket'
            t.input :chest_pocket_satin, as: :boolean, label: 'With Satin'
            t.input :front_side_pocket, label: 'Side Pockets'
            t.input :side_pockets_flap, as: :boolean, label: 'With Flap'
            # (Not applicable for patch chest pocket option and no chest pocket option)
            t.input :side_pockets_satin, as: :boolean, label: 'With Satin'
            t.input :side_pockets_ticket, as: :boolean, label: 'With Ticket Pocket'
            t.input :side_pocket_placement, label: 'Side Pocket Placement'
            t.input :monogram_initials
            # incl. others and will type their option
            t.input :monogram_placement
            # incl. others and will type their option
            t.input :monogram_font 
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
            t.input :vest_style, label: 'Vest Model'
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
            #shirt length
            t.input :shirt_length
            t.input :back_width
            t.input :right_cuff
            t.input :left_cuff
            t.input :chest
            t.input :shirt_waist
            t.input :stature
            t.input :shoulders
            t.input :opening
            t.input :front_placket, label: 'Front Bar'
            t.input :no_of_studs
            t.input :front_pleats
            t.input :back_pleats
            t.input :pocket, label: 'Front Pocket'
            t.input :with_flap, as: :boolean
            t.input :front_pocket_flap
            t.input :sleeve_length
            t.input :cuffs
            t.input :collar
            t.input :buttoned_down, as: :boolean
            t.input :buttoned_down_with_loop, as: :boolean
            t.input :bottom, label: 'Hem'
            t.input :sleeves, label: 'Contrast'
            t.input :contrast_placement
            t.input :monogram_initials
            t.input :monogram_placement
            t.input :monogram_font
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
        attributes_table title: 'Information' do
          row :jo_number
          row :client
        row :status
          #humanize to remove underscore
        row :purpose do |order|
          order.purpose.humanize
        end
        row :type_of_service
        row :brand_name
      end
    end
    column do
      tabs do
        tab 'Coats' do
          attributes_table title: 'Coat Measurements' do
            row :jacket_length
            row :back_width
            row :sleeves
            row :cuffs_1
            row :cuffs_2
            row :collar
            row :chest
            row :waist
            row :hips
          end
        end
        tab 'Pants' do
          attributes_table title: 'Pants Measurements' do
          row :waist
          row :seat
          row :thigh
          row :knee
          row :bottom
          row :outseam
          end
        end
        tab 'Shirts' do
          attributes_table title: 'Shirt Measurements' do
          row :chest
          row :waist
          row :sleeves
          row :collar
          row :cuffs
          row :length
          end
        end
        tab 'Vests' do
          attributes_table title: 'Vest Measurements' do
          row :chest
          row :waist
          row :hips
          row :back_width
          row :vest_length
          end
        end
      end
    end
    column do
      attributes_table title: 'Date Details' do
        row :"Date Created", :created_at do |order|
          order.created_at.strftime('%B %d %Y')
        end
        row :first_fitting
        row :second_fitting
        row :third_fitting
        row :event_date
        row :finish
        end
      end
    end
  
    tabs do
      if order.coats.any?
        tab 'Coat' do
          table_for order.coats do
            column :fabric_consumption
            column :breast
            column :control_no
            column :jacket_length
            column :back_width
            column :sleeves
            column :cuffs_1
            column :cuffs_2
            column :collar
            column :chest
            column :waist
            column :hips
            column :stature
            column :shoulders
            column :remarks
          end
        end
      end

      if order.coats.any?
        tab 'Coat Style' do
          if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Coat Maker'])
            table_for order.coats do
              column :quantity
              column :fabric_consumption
              column :fabric_code
              column :lining_code
              column :style
              column :lapel_style
              column :vent
              column :lining
              column :sleeves_and_padding
              column "Type of Sleeve Button" do |coat|
                coat.button
              end
              column :sleeve_buttons
              column :boutonniere
              column :boutonniere_color
              column :boutonniere_thread_code
              column :button_spacing
              column :coat_pockets
            end
          end
        end
      end

      if order.pants.any?
        tab 'Pants' do
            if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Coat Maker'])
            panel 'Pants Measurements' do
              table_for order.pants do
              column :quantity
              column :fabric_code
              column :lining_code
              column :fabric_consumption
              column :crotch
              column :outseam
              column :waist
              column :seat
              column :thigh
              column :knee
              column :bottom
              column :rise
              column :cut
              column "Pleats" do |pant|
                pant.pleats_combined
              end
              column :strap
              column :waistband_thickness
              column :waist_area
              column "Tightening" do |pant|
                pant.waist_area
              end
              column :closure
              column :crotch_saddle
              end
            end

            panel 'Pants Details' do
              table_for order.pants do
              column "Front Pocket" do |pant|
                pant.type_of_pocket
              end
              column :coin_pocket
              column :flap_on_coin_pocket
              column :back_pocket
              column :flap_on_jetted_pocket
              column :buttons_on_jetted_pockets
              column :button_loops_on_jetted_pockets
              column :add_suspender_buttons
              column :satin_trim
              column :cuff_on_hem
              column :width_of_cuff
              column :remarks
              end
            end
            end
        end
      end

      if order.vests.any?
        tab 'Vest' do
          if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Vest Maker'])
            table_for order.vests do
              column :quantity
              column :fabric_code
              column :lining_code
              column :fabric_consumption
              column :vest_length
              column :back_width
              column :chest
              column :waist
              column :hips
              column "Vest Model" do |vest|
                vest.vest_style
              end
              column :lapel_style
              column :lapel_width
              column :fabric
              column :adjuster_type
              column :side_pocket
              column :remarks
            end
          end
        end
      end

      if order.shirts.any?
        tab 'Shirt' do
          if current_user.role.in?(['Administrator', 'Master Tailor', 'Sales Assistant', 'Production Manager', 'Vest Maker'])
            panel 'Shirt Measurements' do
              table_for order.shirts do
                column :quantity
                column :fabric_code
                column :lining_code
                column :fabric_consumption
                column :shirt_length
                column :back_width
                column :right_cuff
                column :left_cuff
                column :chest
                column :shirt_waist
                column :stature
                column :shoulders
                column :sleeve_length
              end
            end

            panel 'Shirt Subsection 1' do
              table_for order.shirts do
          column :opening  
          column :front_placket
          column "Front Bar" do |shirt|
            shirt.front_placket
          end
          column :no_of_studs
          column :front_pleats
          column :back_pleats
          column "Front Pocket" do |shirt|
            shirt.pocket
          end
          column :with_flap
          column :front_pocket_flap
              end
            end

            panel 'Shirt Subsection 2' do
              table_for order.shirts do
          column :cuffs
          column :collar
          column :buttoned_down
          column :buttoned_down_with_loop
          column :bottom
          column "Hem" do |shirt|
            shirt.bottom
          end
          column "Contrast" do |shirt|
            shirt.sleeves
          end
          column :contrast_placement
          column :monogram_initials
          column :monogram_placement
          column :monogram_font
          column :monogram_color
          column :remarks
              end
            end
          end
        end
      end
    end

    panel 'Version History' do
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

