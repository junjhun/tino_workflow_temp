ActiveAdmin.register_page "Calendar Dashboard" do
  menu priority: 2, label: "Calendar Dashboard"
  content do
    date = params[:month] ? Date.parse(params[:month]) : Date.today
    today = Date.today
    orders = Order.includes(:client).where(
      "finish BETWEEN ? AND ? OR first_fitting BETWEEN ? AND ? OR second_fitting BETWEEN ? AND ? OR third_fitting BETWEEN ? AND ? OR fourth_fitting BETWEEN ? AND ?",
      date.beginning_of_month, date.end_of_month,
      date.beginning_of_month, date.end_of_month,
      date.beginning_of_month, date.end_of_month,
      date.beginning_of_month, date.end_of_month,
      date.beginning_of_month, date.end_of_month
    )

    previous_month = date.prev_month
    next_month = date.next_month

    # Navigation buttons for previous and next month
    div class: 'calendar-navigation', style: "margin-bottom: 20px; text-align: center;" do
      span do
        link_to "← Previous Month", admin_calendar_dashboard_path(month: previous_month.strftime('%Y-%m-%d')),
                class: "btn btn-outline-primary", style: "margin: 0 10px; padding: 5px 15px; color: #007bff; border: 1px solid #007bff; text-decoration: none; border-radius: 5px;"
      end
      span style: "font-size: 1.5rem; font-weight: bold; margin: 0 10px; display: inline-block;" do
        h2 "#{date.strftime('%B %Y')}"
      end
      span do
        link_to "Next Month →", admin_calendar_dashboard_path(month: next_month.strftime('%Y-%m-%d')),
                class: "btn btn-outline-primary", style: "margin: 0 10px; padding: 5px 15px; color: #007bff; border: 1px solid #007bff; text-decoration: none; border-radius: 5px;"
      end
    end

    # Legend Table for Colors
    panel "Legend" do
      div style: "display: flex; justify-content: center;" do
        table style: "margin-bottom: 20px; text-align: center; display: inline-table; border-collapse: collapse;" do
          tr do
            td style: "color: blue; font-size: 1.2rem; padding: 5px 10px;" do
              text_node "• Finish"
            end
            td style: "color: orange; font-size: 1.2rem; padding: 5px 10px;" do
              text_node "• F1 (First Fitting)"
            end
            td style: "color: brown; font-size: 1.2rem; padding: 5px 10px;" do
              text_node "• F2 (Second Fitting)"
            end
            td style: "color: green; font-size: 1.2rem; padding: 5px 10px;" do
              text_node "• F3 (Third Fitting)"
            end
            td style: "color: red; font-size: 1.2rem; padding: 5px 10px;" do
              text_node "• F4 (Fourth Fitting)"
            end
          end
        end
      end
    end

    start_date = date.beginning_of_month.beginning_of_week(:sunday)
    end_date = date.end_of_month.end_of_week(:sunday)

    # Render the calendar table
    table id: 'calendar-table', style: "width: 100%; table-layout: fixed; border-collapse: separate; border-spacing: 8px; border: 1px solid #ddd;" do
      thead do
        tr do
          %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].each_with_index do |day, index|
            th day, style: "padding: 8px; background-color: #e0f7fa; text-align: center; color: #004d40; font-weight: bold;"  # Light blue for the days header row
          end
        end
      end
      tbody do
        (start_date..end_date).each_slice(7) do |week|
          tr do
            week.each_with_index do |date_day, index|
              orders_on_this_day = orders.select do |order|
                [order.finish, order.first_fitting, order.second_fitting, order.third_fitting, order.fourth_fitting].include?(date_day)
              end

              # Styling for today's date and weekends
              if date_day == today
                cell_style = "background-color: #fffbcc; color: #333; border: 2px solid #ffd700; border-radius: 8px;" # Light yellow background with gold border
              elsif index == 0 || index == 6  # Sunday and Saturday columns
                cell_style = "background-color: #f3e5f5; color: #333;"  # Light lavender for weekends
              elsif orders_on_this_day.any?
                cell_style = "background-color: #f5f5f5; color: #333;"  # Default style for cells with events
              else
                cell_style = "background-color: #ffffff;"  # Default background for regular days
              end

              td style: "#{cell_style} padding: 10px; vertical-align: top; text-align: center;" do
                strong date_day.day

                if orders_on_this_day.any?
                  ul style: "padding: 0; list-style: none; margin: 10px 0 0 0;" do
                    orders_on_this_day.each do |order|
                      fitting_type = case date_day
                                     when order.first_fitting
                                       { color: 'orange', label: 'F1' }
                                     when order.second_fitting
                                       { color: 'brown', label: 'F2' }
                                     when order.third_fitting
                                       { color: 'green', label: 'F3' }
                                     when order.fourth_fitting
                                       { color: 'red', label: 'F4' }
                                     when order.finish
                                       { color: 'blue', label: 'Finish' }
                                     end

                      li style: "margin-bottom: 5px; font-size: 0.95rem; display: flex; justify-content: space-between; align-items: center; color: #{fitting_type[:color]};" do
                        # Display fitting type and Order ID with "Order #"
                        span do
                          text_node "• #{fitting_type[:label]} - Order ##{order.id}"
                        end

                        # "View Order" button
                        span do
                          link_to "View Order", admin_order_path(order), 
                                  class: "btn btn-sm btn-light custom-view-order-link", 
                                  style: "color: #{fitting_type[:color]}; text-decoration: none; margin-left: 10px;", 
                                  onmouseover: "this.style.textDecoration='underline'; this.style.color='#007bff';", 
                                  onmouseout: "this.style.textDecoration='none'; this.style.color='#{fitting_type[:color]}';"
                        end
                      end
                    end
                  end
                else
                  text_node "<p style='font-size: 0.85rem; color: #6c757d; margin-top: 10px;'>No orders on this day</p>".html_safe
                end
              end
            end
          end
        end
      end
    end
  end
end