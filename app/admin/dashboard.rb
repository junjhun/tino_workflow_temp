ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: 'Dashboard'

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Order Metrics" do
          div class: "dashboard-statistics" do
            # Number of Active Orders (status not done)
            active_orders_count = Order.where.not(status: 'done').count
            div class: "metric" do
              h1 link_to active_orders_count, admin_orders_path(q: { status_not_eq: 'done' })
              span "Active Orders"
            end

            # Fittings for Today
            today = Date.today
            fittings_today_count = Order.where('first_fitting = ? OR second_fitting = ? OR third_fitting = ? OR fourth_fitting = ?', today, today, today, today).count
            div class: "metric" do
              h1 link_to fittings_today_count, admin_orders_path(q: { first_fitting_eq: today, second_fitting_eq: today, third_fitting_eq: today, fourth_fitting_eq: today })
              span "Fittings Today"
            end

            # Fittings for This Week
            beginning_of_week = Date.today.beginning_of_week
            end_of_week = Date.today.end_of_week
            fittings_this_week_count = Order.where('first_fitting BETWEEN ? AND ? OR second_fitting BETWEEN ? AND ? OR third_fitting BETWEEN ? AND ? OR fourth_fitting BETWEEN ? AND ?', beginning_of_week, end_of_week, beginning_of_week, end_of_week, beginning_of_week, end_of_week, beginning_of_week, end_of_week).count
            div class: "metric" do
              h1 link_to fittings_this_week_count, admin_orders_path(q: { first_fitting_gteq: beginning_of_week, first_fitting_lteq: end_of_week, second_fitting_gteq: beginning_of_week, second_fitting_lteq: end_of_week, third_fitting_gteq: beginning_of_week, third_fitting_lteq: end_of_week, fourth_fitting_gteq: beginning_of_week, fourth_fitting_lteq: end_of_week })
              span "Fittings This Week"
            end

            # Orders Olpiana Andres
            orders_olpiana_andres_count = Order.where(brand_name: 'Olpiana Andres').count
            div class: "metric" do
              h1 link_to orders_olpiana_andres_count, admin_orders_path(q: { brand_name_eq: 'Olpiana Andres' })
              span "Orders Olpiana Andres"
            end

            # Orders St. James
            orders_st_james_count = Order.where(brand_name: 'St. James').count
            div class: "metric" do
              h1 link_to orders_st_james_count, admin_orders_path(q: { brand_name_eq: 'St. James' })
              span "Orders St. James"
            end

            # Orders Tiño
            orders_tino_count = Order.where(brand_name: 'Tiño').count
            div class: "metric" do
              h1 link_to orders_tino_count, admin_orders_path(q: { brand_name_eq: 'Tiño' })
              span "Orders Tiño"
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