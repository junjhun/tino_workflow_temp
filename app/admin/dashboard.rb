ActiveAdmin.register_page "Dashboard" do
  menu if: proc { !["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker"].include?(current_user.role) }
  content do
    if ["Administrator", "Master Tailor", "Sales Assistant", "Production Manager"].include?(current_user.role)
    columns do
      column do
        panel "Order Stats" do
          div class: "dashboard-statistics" do

            h3 do
              raw "Total Orders: #{Order.count} " 
            end

            orders_ready_this_week = Order.where(finish: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).count
            
            h3 do
              raw "Orders Ready This Week: #{orders_ready_this_week} " +
              (orders_ready_this_week > 0 ? link_to("View Orders", admin_orders_path(q: { finish_gteq: Time.zone.now.beginning_of_week, finish_lteq: Time.zone.now.end_of_week }), style: "margin-left: 10px;") : "")
            end
            
            orders_ready_this_month = Order.where(finish: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month).count
            
            h3 do
              raw "Orders Ready This Month: #{orders_ready_this_month} " +
              (orders_ready_this_month > 0 ? link_to("View Orders", admin_orders_path(q: { finish_gteq: Time.zone.now.beginning_of_month, finish_lteq: Time.zone.now.end_of_month }), style: "margin-left: 10px;") : "")
            end
          end
        end
      end
      column do
        panel "Fitting Schedule Stats" do
          div class: "dashboard-statistics" do

            first_fittings_count = Order.where(first_fitting: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).count
            second_fittings_count = Order.where(second_fitting: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).count
            third_fittings_count = Order.where(third_fitting: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).count
            fourth_fittings_count = Order.where(fourth_fitting: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).count

            h3 do
              raw "First Fittings This Week: #{first_fittings_count} " +
              (first_fittings_count > 0 ? link_to("View Orders", admin_orders_path(q: { first_fitting_gteq: Time.zone.now.beginning_of_week, first_fitting_lteq: Time.zone.now.end_of_week }), style: "margin-left: 10px;") : "")
            end
            h3 do
              raw "Second Fittings This Week: #{second_fittings_count} " +
              (second_fittings_count > 0 ? link_to("View Orders", admin_orders_path(q: { second_fitting_gteq: Time.zone.now.beginning_of_week, second_fitting_lteq: Time.zone.now.end_of_week }), style: "margin-left: 10px;") : "")
            end
            h3 do
              raw "Third Fittings This Week: #{third_fittings_count} " +
              (third_fittings_count > 0 ? link_to("View Orders", admin_orders_path(q: { third_fitting_gteq: Time.zone.now.beginning_of_week, third_fitting_lteq: Time.zone.now.end_of_week }), style: "margin-left: 10px;") : "")
            end
            h3 do
              raw "Fourth Fittings This Week: #{fourth_fittings_count} " +
              (fourth_fittings_count > 0 ? link_to("View Orders", admin_orders_path(q: { fourth_fitting_gteq: Time.zone.now.beginning_of_week, fourth_fitting_lteq: Time.zone.now.end_of_week }), style: "margin-left: 10px;") : "")
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Orders by Finish Date (Weekly)" do
          div do
            line_chart Order.group_by_week(:finish).count, height: '300px', library: { title: { text: 'Orders Ready per Week', x: -20 } }
          end
        end
      end

      column do
        panel "Orders by Fitting Date (Monthly)" do
          div do
            line_chart Order.group_by_month(:first_fitting).count, height: '300px', library: { title: { text: 'Orders with First Fitting per Month', x: -20 } }
          end
        end
      end
    end

    columns do
      column do
        panel "Order Breakdown by Status" do
          div do
            pie_chart Order.group(:status).count, height: '300px', library: { title: { text: 'Order Status Breakdown', x: -20 } }
          end
        end
      end

      column do
        panel "Fitting Schedule (Weekly)" do
          div do
            bar_chart [
              { name: "First Fitting", data: Order.group_by_week(:first_fitting).count },
              { name: "Second Fitting", data: Order.group_by_week(:second_fitting).count },
              { name: "Third Fitting", data: Order.group_by_week(:third_fitting).count },
              { name: "Fourth Fitting", data: Order.group_by_week(:fourth_fitting).count }
            ], stacked: true, height: '300px', library: { title: { text: 'Weekly Fitting Schedule', x: -20 } }
          end
        end
      end
    end
  end
end
end