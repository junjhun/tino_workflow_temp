ActiveAdmin.register Client do
  menu if: proc { !["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker"].include?(current_user.role) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :order_id, :name, :contact, :email, :IG_handle, :address, :how_did_you_learn_about_us, :referred_by, :shoe_size, :assisted_by, :measured_by, :gender

  action_item :new_order, only: :show do
    link_to 'New Order', new_admin_order_path(client_id: client.id)
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  config.per_page = [10, 20, 50]
  
  filter :orders_client_name, as: :select, label: "Client Name", collection: Client.all.map { |order| order.name}
  filter :referred_by
  filter :created_at

  index do              
    column :name do |client|
      link_to client.name, admin_client_path(client)
    end
    column "Latest Order" do |client|        # Show the latest order for each client
      if client.orders.any?
        link_to "#{client.orders.order(created_at: :desc).first.jo_number}", admin_order_path(client.orders.order(created_at: :desc).first) 
      end
    end      
    column :contact
    column :referred_by
    column :"Date Created", sortable: :created_at do |client|
      client.created_at.strftime("%d %b %Y") 
    end 
    actions
      
  end

  controller do
    def scoped_collection
      super.includes(:orders).distinct
    end
  end

  # actions :index, :show, :new, :edit, :update do |client|    
  #   item "View Client", admin_client_path(client)
  #   # item "Edit Client", edit_admin_client_path(client) if can?(:edit, client) 
  # end

  #scope :all
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

  action_item :new_order, only: :show do 
    link_to "New Order", new_admin_order_path(client_id: client.id), method: :get 
  end

  action_item :destroy, only: :show do 
    link_to "Delete", admin_client_path(client), method: :delete, 
           data: { confirm: "Are you sure you want to delete this client?" } if client.orders.empty?
  end

end
