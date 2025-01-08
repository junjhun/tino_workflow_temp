ActiveAdmin.register_page 'Dashboard' do
  # menu if: proc { !["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker"].include?(current_user.role) }
  # content do
  #   if ["Administrator", "Master Tailor", "Sales Assistant", "Production Manager"].include?(current_user.role)
  #   columns do
  #     column do
  #       panel "Order Stats" do
  #         div class: "dashboard-statistics" do

  # content title: proc { I18n.t("active_admin.dashboard") } do

  #   panel "Workflow Statistics", class:"text-center" do
  #     columns do
  #       column do
  #         link_to "Orders", admin_orders_path(q: { "fitting_dates": [Date.today, Date.today] }.to_query)
  #           # Calculate total orders this month
  #           total_orders_this_month = Order.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).count
  #           # Display the count
  #           div class: "square-div" do
  #             h1 total_orders_this_month
  #             div do
  #               span "Orders this Month"
  #             end
  #           end
  #       end
  #       column do
  #           # Calculate fittings this week (adjust date range and logic as needed)
  #           fittings_this_week = Order.where(status: 'pending_approval').count
  #           start_of_week = Date.today.beginning_of_week
  #           end_of_week = Date.today.end_of_week
  #           fittings_this_week = Order.where(status: 'pending_approval').count
  #           # Display the count
  #           div class: "square-div" do
  #             h1 3
  #             div do
  #               span "Fittings this Week"
  #             end
  #           end

  #         # end
  #       end

  #       column do

  #           # Calculate total orders awaiting approval (adjust status logic as needed)
  #           # Display the count
  #           div class: "square-div" do
  #             h1  Client.count
  #             div do
  #               span "Total Clients"
  #             end
  #           end

  #       end

  #       column do

  #           # Display the count
  #           div class: "square-div" do
  #             h1 Order.count
  #             div do
  #               span "Total Orders"
  #             end
  #           end

  #         # end
  #       end
  #   end
  # end
  #   panel ""  do
  #     columns do
  #       column do
  #         panel "Recent Orders" do
  #           table_for Order.order(created_at: :desc).limit(5) do
  #             column :jo_number do | order |
  #               link_to order.jo_number, admin_order_path(order)
  #             end
  #             span
  #             column :client
  #             column :created_at
  #             column :first_fitting
  #             column :second_fitting
  #             column :finish
  #           end
  #         end
  #       end

  #       # column do
  #       #   panel "Statistics" do
  #       #     div class: "stats" do
  #       #       ul do
  #       #         # li "Total Orders: #{Order.count}"
  #       #         li "Orders This Month: #{Order.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count}"
  #       #         li "Pending Fittings: #{Order.where(status: :ready_for_fitting).count}"
  #       #         li "New Clients: #{Client.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count}"
  #       #       end
  #       #     end
  #       #   end
  #       # end
  #     end
  #   end
  # end
end
