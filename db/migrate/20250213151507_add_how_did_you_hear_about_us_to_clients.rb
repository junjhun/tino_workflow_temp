class AddHowDidYouHearAboutUsToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :heard_from_source, :integer
  end
end
