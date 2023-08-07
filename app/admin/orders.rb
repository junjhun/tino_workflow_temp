ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :name, :status, :purpose, :MTO_labor, :first_fitting, :second_fitting, :finish, :jo_number, items_attributes: %i[id name quantity fabric_and_linning_code _destroy], coats_attributes: %i[id breast quantity coat_no jacket_length back_width sleeves cuffs_1 cuffs_2 collar chest waist hips stature shoulders remarks fabric_code lining_code style collar_style back lining sleeves_and_padding button sleeve_buttons boutonniere boutonniere_color boutonniere_thread_code button_spacing shoulder_pocket coat_pockets notch vent double_breasted peak shawl _destroy], pants_attributes: %i[id pleats quantity fabric_code lining_code crotch outsteam waist seat thigh remarks knee bottom remarks _destroy]
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
      f.input :MTO_labor
      f.input :first_fitting
      f.input :second_fitting
      f.input :finish
      f.input :jo_number
    end

    f.inputs 'Coats' do
      f.has_many :coats, allow_destroy: true, heading: '' do |t|
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
        t.input :style
        t.input :collar_style
        t.input :back
        t.input :lining
        t.input :sleeves_and_padding
        t.input :button
        t.input :sleeve_buttons
        t.input :no_of_buttons
        t.input :boutonniere
        t.input :boutonniere_color
        t.input :boutonniere_thread_code
        t.input :button_spacing
        t.input :shoulder_pocket
        t.input :coat_pockets

        t.input :"notch"
        t.input :vent
        t.input :double_breasted
        t.input :peak
        t.input :shawl
      end
    end

    f.inputs 'Pants' do
      f.has_many :pants, allow_destroy: true, heading: '' do |t|
        t.input :pleats
        t.input :quantity
        t.input :lining_code
        t.input :crotch
        t.input :outsteam
        t.input :waist
        t.input :seat
        t.input :thigh
        t.input :knee
        t.input :bottom
        t.input :remarks
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
      row :MTO_labor
    end

    panel 'Coat' do
      table_for order.coats do
        column :breast
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
        column :collar_style
        column :back
        column :lining
        column :sleeves_and_padding
        column :button
        column :sleeve_buttons
        column :boutonniere
        column :boutonniere_color
        column :boutonniere_thread_code
        column :button_spacing
        column :shoulder_pocket
        column :coat_pockets
      end
    end

    panel 'Pants' do
      table_for order.pants do
        column :pleats
        column :quantity
        column :fabric_code
        column :lining_code
        column :crotch
        column :outsteam
        column :waist
        column :seat
        column :thigh
        column :knee
        column :bottom
        column :remarks
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
