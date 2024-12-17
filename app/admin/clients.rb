ActiveAdmin.register Client do
  menu if: proc { !["Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker"].include?(current_user.role) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :order_id, :name, :contact, :email, :IG_handle, :address, :how_did_you_learn_about_us, :referred_by, :shoe_size, :assisted_by, :measured_by, :gender

  action_item :new_order, only: :show do
    link_to 'New Order', new_admin_order_path(client_id: client.id)
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
