module ApplicationHelper
    def calendar(number_of_days:)
      (Date.today..(Date.today + number_of_days)).each do |date|
        yield date
      end
    end
  end