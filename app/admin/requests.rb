ActiveAdmin.register Request do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  action_item :view, only: :show do
    link_to 'Approve', approve_admin_requests_path(request), method: :post if request.status != "DONE"
  end

  collection_action :approve, method: :post do
    # Do some CSV importing work here...
    id = params[:format].to_i
    request = Request.find(id)
    status = request.status

    new_status = case status
    when "Client Appontment"
      "JO's to receive by the PRODUCTION MANAGER (LAS PIÑAS)"
    when "JO's to receive by the PRODUCTION MANAGER (LAS PIÑAS)"
      "PRODUCTION MANAGER to handover the following to the MASTER TAILOR (LAS PIÑAS)"
    when "PRODUCTION MANAGER to handover the following to the MASTER TAILOR (LAS PIÑAS)"
      "MASTER TO TAILOR TO HAND OVER THE ROLLED FABRIC AND PATTERN WITH JO TO THE PROD MANAGER (LAS PIÑAS)"
    when "MASTER TO TAILOR TO HAND OVER THE ROLLED FABRIC AND PATTERN WITH JO TO THE PROD MANAGER (LAS PIÑAS)"
      "PRODUCTION MANAGER TO DISTRIBUTE TO MANANAHI TO ASSEMBLE THE PRODUCT FOR 1ST FITTING"
    when "PRODUCTION MANAGER TO DISTRIBUTE TO MANANAHI TO ASSEMBLE THE PRODUCT FOR 1ST FITTING"
      "ONCE DONE, THE PRODUCT WILL BE DELIVERED TO STORE IN MAKATI FOR CLIENT'S FIRST FITTING"
    when "ONCE DONE, THE PRODUCT WILL BE DELIVERED TO STORE IN MAKATI FOR CLIENT'S FIRST FITTING"
      "GIVE THE FITTING GARMENT TO MASTER TAILOR AND PATTERN FOR AREGLO IN PREPS FOR 2ND FITTING"
    else
      "DONE"
    end

    request.update(status: new_status)
    redirect_to collection_path, notice: "Request from #{ request.name } has been updated to #{ new_status }"
  end
end
