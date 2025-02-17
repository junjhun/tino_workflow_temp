ActiveAdmin.register Order do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :name, :status, :purpose, :type_of_service, :first_fitting, :second_fitting, :third_fitting, :fourth_fitting, :finish, :jo_number, :brand_name, :item_type,
                items_attributes: %i[id name quantity fabric_and_linning_code _destroy],
                vests_attributes: %i[id quantity fabric_consumption side_pocket chest_pocket vest_length back_width chest waist hips vest_style remarks number_of_front_buttons lapel_style adjuster_type _destroy],
                shirts_attributes: %i[id quantity fabric_consumption specs_form number_of_buttons shirting_barong fabric_label fabric_code lining_code remarks collar cuffs pleats front_placket back_placket sleeves pocket collar bottom type_of_button control_no _destroy],
                coats_attributes: %i[id fabric_consumption specs_form fabric_label no_of_buttons breast quantity coat_no jacket_length back_width sleeves cuffs_1 cuffs_2 collar chest waist hips stature shoulders remarks fabric_code lining_code style lapel_style vent lining sleeves_and_padding button sleeve_buttons boutonniere boutonniere_color boutonniere_thread_code button_spacing coat_pockets vent control_no pocket_type front_side_pocket _destroy],
                pants_attributes: %i[id fabric_consumption type_of_pocket pleat_style specs_form fabric_label pleats quantity fabric_code lining_code crotch outseam waist seat thigh remarks knee bottom remarks control_no back_pocket strap pant_cuffs add_suspender_buttons no_of_pleats waist_area _destroy]
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
    column :purpose
    column :created_at do |order|
      order.created_at.strftime('%B %d %Y')
    end
    column :finish
    actions

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
      
      # f.input :client_id, as: :select, collection: Client.all.map { |c| [c.name, c.id] },
                          # disabled: f.object.persisted?

      f.input :purpose
      f.input :brand_name, as: :select, collection: Order.brand_names.keys
      f.input :type_of_service, label: 'Type of Service'
      f.input :first_fitting, input_html: { id: 'first_fitting', class: 'datepicker' }
      f.input :second_fitting, input_html: { id: 'second_fitting', class: 'datepicker' }
      f.input :third_fitting, input_html: { id: 'third_fitting', class: 'datepicker' }
      f.input :fourth_fitting, input_html: { id: 'fourth_fitting', class: 'datepicker' }
      f.input :finish
      f.input :jo_number
    end

    # f.inputs 'Select Garment Item' do
    #   f.input :item_type, as: :select, collection: ['Coats', 'Pants/Skirt', 'Vests', 'Shirts'],
    #                       input_html: { id: 'item-type-selector' }
    # end

    tabs do
      tab 'Coats' do
        # Content for the Coat section
        f.inputs 'Coats', id: 'coats-section' do
          f.has_many :coats, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_consumption
            t.input :specs_form
            t.input :control_no
            t.input :breast
            t.input :jacket_length
            t.input :back_width
            t.input :sleeves
            t.input :cuffs_1
            t.input :cuffs_2
            t.input :collar
            t.input :chest
            t.input :waist
            t.input :hips
            t.input :stature
            t.input :shoulders
            t.input :pocket_type
            t.input :front_side_pocket
            t.input :remarks

            t.input :fabric_code
            t.input :lining_code
            t.input :fabric_label
            t.input :style
            t.input :lapel_style
            t.input :vent
            t.input :lining
            t.input :sleeves_and_padding
            t.input :button
            t.input :sleeve_buttons
            t.input :no_of_buttons
            t.input :boutonniere
            t.input :boutonniere_color
            t.input :boutonniere_thread_code
            t.input :button_spacing
            t.input :coat_pockets
          end
        end
      end
      tab 'Pants/Skirt' do
        f.inputs 'Pants/Skirt', id: 'pants-skirt-section' do
          f.has_many :pants, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_consumption
            t.input :specs_form
            t.input :control_no
            t.input :pleats
            t.input :fabric_label
            t.input :fabric_code
            t.input :lining_code
            t.input :crotch
            t.input :outseam
            t.input :waist
            t.input :seat
            t.input :thigh
            t.input :knee
            t.input :bottom
            t.input :back_pocket
            t.input :strap
            t.input :pant_cuffs
            t.input :pleat_style
            t.input :type_of_pocket
            t.input :add_suspender_buttons
            t.input :no_of_pleats
            t.input :waist_area
            t.input :remarks
          end
        end
      end
    
      tab 'Vests' do

        f.inputs 'Vests', id: 'vests-section' do
          f.has_many :vests, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_consumption
            t.input :side_pocket
            t.input :chest_pocket
            t.input :vest_length
            t.input :back_width
            t.input :chest
            t.input :waist
            t.input :hips
            t.input :vest_style
            t.input :lapel_style
            t.input :adjuster_type
            t.input :number_of_front_buttons
            t.input :remarks
          end
        end
      end

      tab 'Shirts' do
        f.inputs 'Shirts', id: 'shirts-section' do
          f.has_many :shirts, allow_destroy: true, heading: '' do |t|
            t.input :quantity
            t.input :fabric_consumption
            t.input :specs_form
            t.input :control_no
            t.input :fabric_label
            t.input :fabric_code
            t.input :lining_code
            t.input :remarks
            t.input :cuffs
            t.input :pleats
            t.input :front_placket
            t.input :back_placket
            t.input :sleeves
            t.input :pocket
            t.input :collar
            t.input :bottom
            t.input :type_of_button
          end
        end
      end
    end
    f.actions
  end
  
  show do
    
    #go back button
    div class: 'back-button' do
      link_to '← Back', admin_orders_path
    end

    columns do      
      column do
        attributes_table title: 'Information' do
          row :jo_number
          row :client
          row :status
          row :purpose
          row :type_of_service
          row :brand_name          
        end
      end
      column do
        attributes_table title: 'Default Body Measurements' do
          row :chest
          row :back_width
          row :waist
          row :crotch
          row :thigh
          row :seat
          row :hips
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
          row :fourth_fitting
          row :finish
        end
      end
    end

    tabs do
      if order.coats.any?
        tab 'Coat' do
          # Content for the Coat section
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
          # Content for the Panel section
          if current_user.role == 'Administrator' || current_user.role == 'Master Tailor' || current_user.role == 'Sales Assistant' || current_user.role == 'Production Manager' || current_user.role == 'Coat Maker'
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
              column :button
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
          if current_user.role == 'Administrator' || current_user.role == 'Master Tailor' || current_user.role == 'Sales Assistant' || current_user.role == 'Production Manager' || current_user.role == 'Coat Maker'
            table_for order.pants do
              column :quantity
              column :fabric_consumption
              column :control_no
              column :pleats
              column :fabric_code
              column :lining_code
              column :crotch
              column :outseam
              column :waist
              column :seat
              column :thigh
              column :knee
              column :bottom
              column :remarks
            end
          end
        end
      end

      if order.vests.any?
        tab 'Vest' do
          # Content for the Vest section
          if current_user.role == 'Administrator' || current_user.role == 'Master Tailor' || current_user.role == 'Sales Assistant' || current_user.role == 'Production Manager' || current_user.role == 'Vest Maker'
            table_for order.vests do
              column :quantity
              column :fabric_consumption
              column :side_pocket
              column :vest_length
              column :back_width
              column :chest
              column :waist
              column  :hips
              column  :vest_style
              column  :remarks
              column  :number_of_front_buttons
              column  :lapel_style
              column  :adjuster_type
            end
          end
        end
      end

      if order.shirts.any?
        tab 'Shirt' do
          if current_user.role == 'Administrator' || current_user.role == 'Master Tailor' || current_user.role == 'Sales Assistant' || current_user.role == 'Production Manager' || current_user.role == 'Vest Maker'
            table_for order.shirts do
              column :quantity
              column :fabric_consumption
              column :control_no
              column :shirting_barong
              column :fabric_label
              column :brand_label
              column :tafetta
              column  :fabric_code
              column  :lining_code
              column  :remarks
              column  :cuffs
              column  :pleats
              column  :front_placket
              column  :back_placket
              column  :sleeves
              column  :number_of_buttons
              column  :pocket
              column  :collar
              column  :bottom
            end
          end
        end
      end
    end
    active_admin_comments
  end


  controller do
    before_action :restrict_new_order_for_makers, only: :new
    before_action :restrict_actions_for_makers, only: %i[edit destroy approve]

    private
    # Restrict makers from accessing "New Order"
    def restrict_new_order_for_makers
      if ['Coat Maker', 'Pants Maker', 'Shirt Maker', 'Vest Maker', 'Production Manager'].include?(current_user.role)
        redirect_to admin_orders_path, alert: 'You are not authorized to create new orders.'
      end
    end
    
    private 
    # Restrict makers from accessing "Edit" and "Delete"
    def restrict_actions_for_makers
      if ['Coat Maker', 'Pants Maker', 'Shirt Maker', 'Vest Maker', 'Production Manager'].include?(current_user.role)
        redirect_to admin_orders_path, alert: 'You are not authorized to perform this action.'
      end
    end
  end

  
  action_item :view, only: :show do
    link_to 'Approve', approve_admin_orders_path(order), method: :post if order.status != 'DONE'
  end



  #   # Conditionally show actions based on the user role
  #   if ['Coat Maker', 'Pants Maker', 'Shirt Maker', 'Vest Maker'].include?(current_user.role)
  #     # For maker roles, only show the View action
  #     actions defaults: false do |order|
  #       item 'View', admin_order_path(order)
  #     end
  #   else
  #     # For other roles, show all actions (View, Edit, Delete)
  #     actions
  #   end
  # end

  action_item :import_demo, only: :show do |_p|
    link_to 'Master Print', reports_order_path(order, type: 'Master')
  end

  action_item :import_demo, only: :show do |_p|
    link_to 'Coats Print', reports_order_path(order, type: 'Coats')
  end

  action_item :import_demo, only: :show do |_p|
    link_to 'Pants Print', reports_order_path(order, type: 'Pants')
  end

  action_item :import_demo, only: :show do |_p|
    link_to 'Shirts Print', reports_order_path(order, type: 'Shirts')
  end

  action_item :import_demo, only: :show do |_p|
    link_to 'Vests Print', reports_order_path(order, type: 'Vests')
  end

  
  # Filter side bar
  filter :client_name, as: :select, label: 'Client Name', collection: Client.all.map { |order| order.name }
  filter :type_of_service, as: :select, label: 'Type of Service', collection: Order.type_of_services.keys
  filter :jo_number, as: :select, label: 'Job Order #', collection: proc { Order.distinct.pluck(:jo_number) } 
  filter :purpose, as: :select, collection: Order.distinct.pluck(:purpose)
  filter :created_at
end
