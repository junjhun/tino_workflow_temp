class PagesController < ApplicationController
  def home
    # Fetch clients and group them by the date they were created
    @clients = Client.all.group_by { |client| client.created_at.to_date }
  end
end
