ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :name, :status, items_attributes: %i[id name quantity fabric_and_linning_code _destroy]
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
    end

    f.inputs 'Items' do
      f.has_many :items, allow_destroy: true, heading: '' do |t|
        t.input :name
        t.input :quantity
        t.input :fabric_and_linning_code
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :status
    end

    panel 'Item' do
      table_for order.items do
        column 'Name' do |p|
          p.name
        end

        column 'Quantity' do |p|
          p.quantity
        end

        column 'Fabric and Linning_code' do |p|
          p.fabric_and_linning_code
        end
      end
    end

    active_admin_comments
  end

end
