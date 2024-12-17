class Client < ApplicationRecord
    has_many :orders, class_name: 'Order'

    enum gender: [
        "Male",
        "Female"
    ]

    enum how_did_you_learn_about_us:[
      "Google",
      "Facebook",
      "Instagram",
      "Referral",
      "Others"
    ]

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :contact, presence: true
    validates :email, presence: true
    validates :IG_handle, presence: true
    validates :address, presence: true
    validates :how_did_you_learn_about_us, presence: true
    validates :referred_by, presence: true
    validates :shoe_size, presence: true
    validates :gender, presence: true
    validates :assisted_by, presence: true
    validates :measured_by, presence: true

    before_save :uppercase_name
    
    
    private
  
    def uppercase_name
      self.name = name.upcase if name.present?
      self.referred_by = referred_by.upcase if referred_by.present?
      self.assisted_by = assisted_by.upcase if assisted_by.present?
      self.measured_by = measured_by.upcase if measured_by.present?
    end
end

