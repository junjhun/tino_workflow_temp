class CapitalizeClientNames < ActiveRecord::Migration[7.0]
  def change
    Client.find_each do |client|
      client.update!(name: client.name.titleize)
    end
  end
end
