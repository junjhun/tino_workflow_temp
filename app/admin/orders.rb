ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :name, :status, :purpose, :type_of_service, :first_fitting, :second_fitting, :finish, :jo_number, :brand_name,
                items_attributes: %i[id name quantity fabric_and_linning_code _destroy],
                vests_attributes: %i[id side_pocket chest_pocket vest_length back_width chest waist hips vest_style :remarks :number_of_front_buttons :lapel_style :adjuster_type _destroy],
                shirts_attributes: %i[id specs_form number_of_buttons shirting_barong fabric_label brand_label tafetta fabric_code lining_code remarks collar cuffs pleats placket sleeves pocket collar bottom control_no _destroy],
                coats_attributes: %i[id specs_form tafetta fabric_label brand_label no_of_buttons breast quantity coat_no jacket_length back_width sleeves cuffs_1 cuffs_2 collar chest waist hips stature shoulders remarks fabric_code lining_code style lapel_style vent lining sleeves_and_padding button sleeve_buttons boutonniere boutonniere_color boutonniere_thread_code button_spacing coat_pockets vent control_no _destroy],
                pants_attributes: %i[id specs_form tafetta fabric_label brand_label pleats quantity fabric_code lining_code crotch outseam waist seat thigh remarks knee bottom remarks control_no _destroy]
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  action_item :view, only: :show do
    link_to 'Approve', approve_admin_orders_path(order), method: :post if order.status != "DONE"
  end

  collection_action :approve, method: :post do
    # Do some CSV importing work here...
    id = params[:format].to_i
    order = Order.find(id)
    status = order.status

    new_status = case status
    when "Client Appontment"
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
      f.input :client
      f.input :purpose
      f.input :type_of_service, label: "Type of Service"
      f.input :brand_name
      f.input :first_fitting
      f.input :second_fitting
      f.input :finish
      f.input :jo_number
    end

    f.inputs 'Coats' do
      f.has_many :coats, allow_destroy: true, heading: '' do |t|
        t.input :specs_form
        t.input :control_no
        t.input :breast
        t.input :quantity
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
        t.input :remarks

        t.input :fabric_code
        t.input :lining_code
        t.input :fabric_label
        t.input :tafetta
        t.input :brand_label
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
        t.input :vent
      end
    end

    f.inputs 'Pants/Skirt' do
      f.has_many :pants, allow_destroy: true, heading: '' do |t|
        t.input :specs_form
        t.input :control_no
        t.input :pleats
        t.input :quantity
        t.input :fabric_label
        t.input :brand_label
        t.input :tafetta
        t.input :fabric_code
        t.input :lining_code
        t.input :crotch
        t.input :outseam
        t.input :waist
        t.input :seat
        t.input :thigh
        t.input :knee
        t.input :bottom
        t.input :remarks
      end
    end

    f.inputs 'Vests' do
      f.has_many :vests, allow_destroy: true, heading: '' do |t|
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

    f.inputs 'Shirts' do
      f.has_many :shirts, allow_destroy: true, heading: '' do |t|
        t.input :specs_form
        t.input :control_no
        t.input :fabric_label
        t.input :brand_label
        t.input :tafetta
        t.input :fabric_code
        t.input :lining_code
        t.input :remarks
        t.input :cuffs
        t.input :pleats
        t.input :placket
        t.input :sleeves
        t.input :pocket
        t.input :collar
        t.input :bottom
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :status
      row :jo_number
      row :client
      row :purpose
      row :type_of_service
    end

  if current_user.role == "Administrator" || current_user.role == "Master Tailor" || current_user.role == "Sales Assistant" || current_user.role == "Production Manager" || current_user.role == "Coat Maker"

    panel 'Coat' do
      table_for order.coats do
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
          column :control_no
          column :pleats
          column :quantity
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
          column  :placket
          column  :sleeves
          column  :number_of_buttons
          column  :pocket
          column  :collar
          column  :bottom
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

  action_item :import_demo, only: :show do |p|
    link_to 'Print', reports_order_path(order)
  end
end
