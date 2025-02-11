# filepath: /Users/caan/Development/Tiño/joborder/workflow/app/admin/dashboard.rb
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: 'Dashboard'

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Order Metrics" do
          div class: "dashboard-statistics" do
            # Total Orders This Month
            total_orders_this_month = Order.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).count
            div class: "metric" do
              h1 link_to total_orders_this_month, admin_orders_path(q: { created_at_gteq: Time.now.beginning_of_month, created_at_lteq: Time.now.end_of_month })
              span "Orders This Month"
            end

            # Total Orders This Week
            total_orders_this_week = Order.where(created_at: Time.now.beginning_of_week..Time.now.end_of_week).count
            div class: "metric" do
              h1 link_to total_orders_this_week, admin_orders_path(q: { created_at_gteq: Time.now.beginning_of_week, created_at_lteq: Time.now.end_of_week })
              span "Orders This Week"
            end

            # Orders by Status
            Order.statuses.keys.each do |status|
              orders_by_status = Order.where(status: status).count
              div class: "metric" do
                h1 link_to orders_by_status, admin_orders_path(q: { status_eq: status })
                span "Orders #{status.titleize}"
              end
            end

            # Orders by Type of Service
            Order.type_of_services.keys.each do |service|
              orders_by_service = Order.where(type_of_service: service).count
              div class: "metric" do
                h1 link_to orders_by_service, admin_orders_path(q: { type_of_service_eq: service })
                span "Orders #{service.titleize}"
              end
            end

            # Orders by Brand
            Order.brand_names.keys.each do |brand|
              orders_by_brand = Order.where(brand_name: brand).count
              div class: "metric" do
                h1 link_to orders_by_brand, admin_orders_path(q: { brand_name_eq: brand })
                span "Orders #{brand.titleize}"
              end
            end
          end

          # Orders Over Time Graph
          div do
            h3 "Orders Over Time"
            line_chart Order.group_by_day(:created_at).count
          end
        end
      end

      column do
        panel "Client Metrics" do
          div class: "dashboard-statistics" do
            # Total Clients
            total_clients = Client.count
            div class: "metric" do
              h1 link_to total_clients, admin_clients_path
              span "Total Clients"
            end

            # New Clients This Month
            new_clients_this_month = Client.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).count
            div class: "metric" do
              h1 link_to new_clients_this_month, admin_clients_path(q: { created_at_gteq: Time.now.beginning_of_month, created_at_lteq: Time.now.end_of_month })
              span "New Clients This Month"
            end
          end

          # Clients Over Time Graph
          div do
            h3 "Clients Over Time"
            line_chart Client.group_by_day(:created_at).count
          end
        end
      end
    end
  end
end