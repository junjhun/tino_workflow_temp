ActiveAdmin.register Client do
  menu if: proc { !['Coat Maker', 'Pants Maker', 'Shirt Maker', 'Vest Maker'].include?(current_user.role) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :order_id, :name, :contact, :email, :IG_handle, :address, :heard_from_source, :referred_by,
              :shoe_size, :assisted_by, :measured_by, :gender, :first_fitting, :second_fitting, :chest, :back_width,
              :waist, :crotch, :thigh, :seat, :hips, :date_of_birth, :membership_date, :linkedin_handle, :viber_handle

  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  config.per_page = [10, 20, 50]

  
  scope :all, default: true do |clients| clients end
  scope :'Male' do |clients| clients.where(gender: '0') end
  scope :'Female' do |clients| clients.where(gender: '1') end
  scope :'Has orders' do |clients| clients.joins(:orders).distinct end
  scope :'Empty Orders' do |clients|clients.where.not(id: clients.joins(:orders).distinct)
  end
  
  
  # actions :all, except: :destroy  # Apply at the resource level for consistency
  
  filter :orders_client_name, as: :select, label: 'Client Name', collection: Client.all.map { |order| order.name }
  filter :assisted_by, as: :select, collection: User.all.map { |user| [user.name, user.id] }
  filter :referred_by
  filter :created_at

  index do
    column :name do |client|
      link_to client.name, admin_client_path(client)
    end
    column "No. of Orders" do |client|
      count = client.orders.count
      count > 0 ? count : "No Orders"
    end

    column :contact, sortable: false
    column :membership_date
    column :referred_by
    column :assisted_by_name, sortable: 'users.name' do |client|
      client.assisted_by_name
    end
    column :"Date Created", sortable: :created_at do |client|
      client.created_at.strftime('%d %b %Y')
    end
    column :is_old_client, label: 'Old Client' do |client|
      status_tag(client.is_old_client? ? 'Yes' : 'No', class: client.is_old_client? ? 'ok' : 'warning')
    end
  end

  controller do
    def scoped_collection
      super.includes(:orders).distinct
    end
  end

  form do |f|
    tabs do
      tab 'Client Details' do
        f.inputs do
          f.input :name
          f.input :gender, as: :select, collection: Client.genders.keys
          f.input :date_of_birth, as: :datepicker, datepicker_options: { changeYear: true, yearRange: "1900:+nn", changeMonth: true , monthRange: "1:12"}
          f.input :address
          f.input :referred_by
          f.input :assisted_by, as: :select, collection: User.all.map { |user| [user.name, user.id] }, include_blank: false
          f.input :measured_by
          f.input :membership_date, as: :datepicker,datepicker_options: { changeYear: true, yearRange: "1900:+nn", changeMonth: true , monthRange: "1:12"}
          f.input :heard_from_source, as: :select, collection: Client.heard_from_sources.keys, input_html: { id: 'heard_from_source' }
          # f.input :heard_from_source_other, input_html: { id: 'heard_from_source_other', style: 'display: none;' }
        end
      end
      
      tab 'Contact Information' do
        f.inputs do
          f.input :contact
          f.input :email
          f.input :IG_handle
          f.input :linkedin_handle
          f.input :viber_handle
        end
      end


      tab 'Measurements' do
        f.inputs do
          f.input :chest
          f.input :back_width
          f.input :waist
          f.input :crotch
          f.input :thigh
          f.input :seat
          f.input :hips
          f.input :shoe_size
        end
      end
    end
  
    f.actions
  end

  # actions :index, :show, :new, :edit, :update do |client|
  #   item "View Client", admin_client_path(client)
  #   # item "Edit Client", edit_admin_client_path(client) if can?(:edit, client)
  # end

  # scope :all
  # scope :with_order_count, default: true

  show do
    tabs do
      tab 'Details' do
        attributes_table do
          row :name
          row :gender
          row :address
          row :heard_from_source
          row :referred_by
          row :created_at
          row :assisted_by_name
          row :is_old_client
        end
      end

      tab 'Contact Information' do
        attributes_table do
          row :contact
          row :email
          row :IG_handle
          row :linkedin_handle
          row :viber_handle
        end
      end

      tab 'Measurements' do
        latest_order = client.orders.order(created_at: :desc).first
        if latest_order
          panel "Measurements from Latest Order (##{latest_order.jo_number})" do
            # Get the first associated record for each type
            coat  = latest_order.coats.first
            pant  = latest_order.pants.first
            shirt = latest_order.shirts.first
            vest  = latest_order.vests.first

            attributes_table_for latest_order do
              row("Jacket Length")    { coat&.jacket_length }
              row("Back Width")       { coat&.back_width }
              row("Sleeves")          { coat&.sleeves }
              row("Right Cuff")       { coat&.cuffs_1 }
              row("Left Cuff")        { coat&.cuffs_2 }
              row("Chest")            { coat&.chest }
              row("Coat Waist")       { coat&.waist }
              row("Stature")          { coat&.stature }
              row("Shoulders")        { coat&.shoulders }
              row("Crotch")           { pant&.crotch }
              row("Outseam")          { pant&.outseam }
              row("Pants Waist")      { pant&.waist }
              row("Seat")             { pant&.seat }
              row("Thigh")            { pant&.thigh }
              row("Knee")             { pant&.knee }
              row("Bottom")           { pant&.bottom }
              row("Shirt Length")     { shirt&.shirt_length }
              row("Vest Length")      { vest&.vest_length }
              row("Vest Back Width")  { vest&.back_width }
              row("Vest Chest")       { vest&.chest }
              row("Vest Waist")       { vest&.waist }
              row("Vest Hips")        { vest&.hips }
            end
          end
        else
          span "No orders found."
        end
      end
    end

    panel 'Orders' do
      table_for client.orders do
        column :jo_number do |order|
          link_to order.jo_number, admin_order_path(order)
        end
        column :type_of_service, label: 'Type of Service'
        column :status
        column :created_at
        column :updated_at
      end
    end

    # active_admin_comments
  end

  action_item :new_order, only: :show do
    link_to 'New Order', new_admin_order_path(client_id: client.id), method: :get
  end

  action_item :destroy, only: :show do
    if client.orders.empty?
      link_to 'Delete', admin_client_path(client), method: :delete,
                                                   data: { confirm: 'Are you sure you want to delete this client?' }
    end
  end
end


