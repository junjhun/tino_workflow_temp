class Order < ApplicationRecord
    include Workflow
    # include WorkflowActiverecord

    # validates :name, presence: true
    # validates :name, presence: true, uniqueness: true
    
    enum status: [
        "Client Appontment", 
        "JO's to receive by the PRODUCTION MANAGER (LAS PIÑAS)",
        "PRODUCTION MANAGER to handover the following to the MASTER TAILOR (LAS PIÑAS)",
        "MASTER TO TAILOR TO HAND OVER THE ROLLED FABRIC AND PATTERN WITH JO TO THE PROD MANAGER (LAS PIÑAS)",
        "PRODUCTION MANAGER TO DISTRIBUTE TO MANANAHI TO ASSEMBLE THE PRODUCT FOR 1ST FITTING",
        "ONCE DONE, THE PRODUCT WILL BE DELIVERED TO STORE IN MAKATI FOR CLIENT'S FIRST FITTING",
        "GIVE THE FITTING GARMENT TO MASTER TAILOR AND PATTERN FOR AREGLO IN PREPS FOR 2ND FITTING",
        "DONE"
    ]

    enum type_of_service: [
        "Bespoke",
        "Bespoke Labor",
        "Made to Order",
        "Ready to Wear"
    ]

    enum brand_name: [
        "Tiño",
        "Olpiana Andres"
    ]


    belongs_to :client
    has_many :coats
    has_many :pants
    has_many :shirts
    has_many :vests

    accepts_nested_attributes_for :coats, :pants, :shirts, :vests

    def name
        client&.name
    end
end
