class AddItem < ApplicationRecord
    belongs_to :orders

    enum item_type: [
        "Coat",
        "Skirt",
        "test"
    ]
end
