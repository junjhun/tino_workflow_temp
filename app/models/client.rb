class Client < ApplicationRecord
  has_many :orders, class_name: 'Order'

  enum gender: %w[
    Male
    Female
  ]

  enum how_did_you_learn_about_us: %w[
    Google
    Facebook
    Instagram
    Referral
    Others
  ]

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :contact, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :how_did_you_learn_about_us, presence: true
  validates :referred_by, presence: true
  validates :gender, presence: true
  # validates :IG_handle, presence: true
  # validates :shoe_size, presence: true
  # validates :assisted_by, presence: true
  # validates :measured_by, presence: true

  before_save :uppercase_name

  private

  def capitalize_client_name
    self.name = name.titleize
  end

  # Prevent deletion of a client if there are associated orders
  validate :cannot_delete_if_orders_exist

  # Method that prevents deletion of a client if there are associated orders

  def cannot_delete_if_orders_exist
    errors.add(:base, 'Cannot delete a client with associated orders') if orders.any?
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

  def order_count
    orders.count
  end

  def uppercase_name
    self.name = name.upcase if name.present?
    self.referred_by = referred_by.upcase if referred_by.present?
    self.assisted_by = assisted_by.upcase if assisted_by.present?
    self.measured_by = measured_by.upcase if measured_by.present?
  end
end
