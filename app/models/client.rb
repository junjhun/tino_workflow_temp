class Client < ApplicationRecord
    has_many :orders , dependent: :restrict_with_error, counter_cache: true

    enum gender: [
        "Male",
        "Female"
    ]

    # Italisize client's name before saving it to the database
    before_save :capitalize_client_name
    # method that capitalizes the client's name before saving it to the database
    private
    def capitalize_client_name
        self.name = self.name.titleize        
    end
    
    # Prevent deletion of a client if there are associated orders
    validate :cannot_delete_if_orders_exist

    # Method that prevents deletion of a client if there are associated orders
    private
    def cannot_delete_if_orders_exist
        errors.add(:base, "Cannot delete a client with associated orders") if orders.any?
    end    

    # before_destroy :prevent_deletion_if_orders_exist

    # private
    # def prevent_deletion_if_orders_exist
    #     if orders.present?
    #     errors.add(:base, "Cannot delete client with existing orders.")
    #     throw(:abort) 
    #     end
    # end

    # default_sort ["order_count", "created_at"], :desc
    private
    def order_count
        orders.count
    end
end

