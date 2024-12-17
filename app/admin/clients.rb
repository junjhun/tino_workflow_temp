ActiveAdmin.register Client do
  menu if: proc { !["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker"].include?(current_user.role) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :order_id, :name, :contact, :email, :address, :how_did_you_learn_about_us, :referred_by, :gender, orders_attributes: [:id, :client_id, :status]
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  filter :orders_client_name, as: :select, label: "Client Name", collection: Order.all.map { |order| order.name}
  filter :referred_by
  filter :created_at

  index do    
      selectable_column
      id_column
      column :name do |client|
        link_to client.name, admin_client_path(client)
      end
      column :order_count do |client|
        client.orders.count
      end
      column :created_at
      column :updated_at
      actions

      # action_item :new_order do
      #   link_to 'New Order', new_admin_order_path(client_id: client.id)
      # end
      
  end

  # scope :all
  # scope :with_order_count, default: true

  show do
    attributes_table do
      row :name
      row :email
      row :gender      
      row :address
      row :contact
      row :how_did_you_learn_about_us
      row :referred_by
    end

    
    panel "Orders" do
      table_for client.orders do
        # column :id do |order|
        #   link_to order.id, admin_order_path(order)
        # end
        column :jo_number do | order |
          link_to order.jo_number, admin_order_path(order)
        end
        column:type_of_service, label: "Type of Service"
        column :status
        column :created_at
        column :updated_at
      end
    end

   # active_admin_comments    

  end

  

  #link_to 'Delete', [:admin, resource], method: :delete, data: { confirm: 'Are you sure? Deleting this client will also delete associated orders.' }, disabled: resource.orders.any?



end


