class CalendarsController < InheritedResources::Base

  private

    def calendar_params
      params.require(:calendar).permit(:title, :description, :start_time, :end_time)
    end

end
