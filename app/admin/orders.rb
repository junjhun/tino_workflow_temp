ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :name, :status, :purpose, :type_of_service, :first_fitting, :second_fitting,:third_fitting,:fourth_fitting, :finish, :jo_number, :brand_name, :item_type,
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

  index do
    selectable_column
    # column :id
    column "Job Order" do | order |
      link_to order.jo_number, admin_order_path(order)
    end
    column :client
    column :created_at
    column :updated_at
    column :type_of_service
    column :status
    actions
  end

  
  action_item :view, only: :show do
    link_to 'Approve', approve_admin_orders_path(order), method: :post if order.status != "DONE"
  end

  collection_action :approve, method: :post do
    # Do some CSV importing work here...
    id = params[:format].to_i
    order = Order.find(id)
    status = order.status

    new_status = case status
    when "Client Appointment"
      "JO's to receive by the PRODUCTION MANAGER (LAS PIÑAS)"
    when "JO's to receive by the PRODUCTION MANAGER (LAS PIÑAS)"
      "PRODUCTION MANAGER to handover the following to the MASTER TAILOR (LAS PIÑAS)"
    when "PRODUCTION MANAGER to handover the following to the MASTER TAILOR (LAS PIÑAS)"
      "MASTER TO TAILOR TO HAND OVER THE ROLLED FABRIC AND PATTERN WITH JO TO THE PROD MANAGER (LAS PIÑAS)"
    when "MASTER TO TAILOR TO HAND OVER THE ROLLED FABRIC AND PATTERN WITH JO TO THE PROD MANAGER (LAS PIÑAS)"
      "PRODUCTION MANAGER TO DISTRIBUTE TO MANANAHI TO ASSEMBLE THE PRODUCT FOR 1ST FITTING"
    when "PRODUCTION MANAGER TO DISTRIBUTE TO MANANAHI TO ASSEMBLE THE PRODUCT FOR 1ST FITTING"
      "ONCE DONE, THE PRODUCT WILL BE DELIVERED TO STORE IN MAKATI FOR CLIENT'S FIRST FITTING"
    when "ONCE DONE, THE PRODUCT WILL BE DELIVERED TO STORE IN MAKATI FOR CLIENT'S FIRST FITTING"
      "GIVE THE FITTING GARMENT TO MASTER TAILOR AND PATTERN FOR AREGLO IN PREPS FOR 2ND FITTING"
    else
      "DONE"
    end

    order.update(status: new_status)
    redirect_to collection_path, notice: "Order from #{ order.name } has been updated to #{ new_status }"
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :status
      f.input :client, :input_html => { :disabled => true }
      f.input :purpose
      f.input :brand_name, input_html: { id: 'type_of_brand' }
      f.input :type_of_service, label: "Type of Service"
      f.input :first_fitting, input_html: { id: 'first_fitting', class: 'datepicker' }
      f.input :second_fitting, input_html: { id: 'second_fitting', class: 'datepicker' }
      f.input :third_fitting, input_html: { id: 'third_fitting', class: 'datepicker' }
      f.input :fourth_fitting, input_html: { id: 'fourth_fitting', class: 'datepicker' }
      f.input :finish
      f.input :jo_number
    end

    f.inputs "Select Item" do
      f.input :item_type, as: :select, collection: ["Coats", "Pants/Skirt", "Vests", "Shirts"], input_html: { id: 'item-type-selector' }
    end
    
    f.inputs 'Coats', id: 'coats-section', style: 'display:none;' do
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

    f.inputs 'Pants/Skirt', id: 'pants-skirt-section', style: 'display:none;' do
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

    f.inputs 'Vests', id: 'vests-section', style: 'display:none;' do
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

    f.inputs 'Shirts', id: 'shirts-section', style: 'display:none;' do
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

    f.actions
  end
  
  show do
    attributes_table do
      row :jo_number
      row :client
      row :status
      row :purpose
      row :type_of_service      
    end

    tabs do
      tab 'Coat' do
        # Content for the Coat section
        attributes_table do
          row :fabric_consumption
          row :breast
          # ... other coat-related attributes
        end
      end

      tab 'Pants' do
        # Content for the Panel section
        attributes_table do
          row :quantity
          row :fabric_consumption
          # ... other panel-related attributes
        end
      end

      tab 'Vest' do
        # Content for the Vest section
        attributes_table do
          row :quantity
          row :fabric_consumption
          # ... other vest-related attributes
        end
      end
    
  end
    
  if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Coat Maker"

    panel 'Coat' do
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


      panel 'Coat Style' do
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

    if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Pants Maker"

      panel 'Pants' do
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

    if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Shirt Maker"

      panel 'Shirts' do
        table_for order.shirts do
          column :quantity
          column :fabric_consumption
          column :control_no
          column :shirting_barong
          column :fabric_label
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


    if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Vest Maker"

      panel 'Vests' do
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

    active_admin_comments
  end

  # controller do
  #   # if you want /admin/pages/12345.pdf
  #   def show
  #     super do |format|
  #       format.pdf { render(pdf: "page-#{resource.id}.pdf") }
  #     end
  #   end
  # end

  controller do
    before_action :restrict_new_order_for_makers, only: :new
    before_action :restrict_actions_for_makers, only: [:edit, :destroy, :approve]

    private

    # Restrict makers from accessing "New Order"
    def restrict_new_order_for_makers
      if ["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker", "Production Manager"].include?(current_user.role)
        redirect_to admin_orders_path, alert: "You are not authorized to create new orders."
      end
    end

    # Restrict makers from accessing "Edit" and "Delete"
    def restrict_actions_for_makers
      if ["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker", "Production Manager"].include?(current_user.role)
        redirect_to admin_orders_path, alert: "You are not authorized to perform this action."
      end
    end
  end

  index do
    selectable_column
    id_column
    column :created_at
    column :updated_at
    column :status
    column :client
    column :purpose
    column :first_fitting
    column :second_fitting
    column :third_fitting
    column :fourth_fitting
    column :finish
    column :jo_number
    column :brand_name
    column :type_of_service
    column :item_type

    # Conditionally show actions based on the user role
    if ["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker"].include?(current_user.role)
      # For maker roles, only show the View action
      actions defaults: false do |order|
        item "View", admin_order_path(order)
      end
    else
      # For other roles, show all actions (View, Edit, Delete)
      actions
    end
  end

  
 
  action_item :import_demo, only: :show do |p|
    link_to 'Master Print', reports_order_path(order, type: 'Master')
  end

  action_item :import_demo, only: :show do |p|
    link_to 'Coats Print', reports_order_path(order, type: 'Coats')
  end

  action_item :import_demo, only: :show do |p|
    link_to 'Pants Print', reports_order_path(order, type: 'Pants')
  end

  action_item :import_demo, only: :show do |p|
    link_to 'Shirts Print', reports_order_path(order, type: 'Shirts')
  end

  action_item :import_demo, only: :show do |p|
    link_to 'Vests Print', reports_order_path(order, type: 'Vests')
  end

  # Filter side bar
  # filter :client_name, as: :select, label: "Client Name", collection: Client.all.map { |order| order.name}  
  filter :type_of_service, as: :select, label: "Type of Service", collection: Order.type_of_services.keys
  filter :created_at
  
end