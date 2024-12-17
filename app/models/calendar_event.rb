class CalendarViewModel
    def initialize
      @events = CalendarEvent.all
    end
  
    def events_for_calendar
      @events.map do |event|
        {
          title: event.title,
          start: event.start_date,
          end: event.end_date,
          description: event.description
        }
      end
    end
  end
  