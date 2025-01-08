module ApplicationHelper
  def calendar(number_of_days:, &block)
    (Date.today..(Date.today + number_of_days)).each(&block)
  end
end
