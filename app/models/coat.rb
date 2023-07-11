class Coat < ApplicationRecord
    belongs_to :order

    enum stature: [
        "Stout", 
        "Prominent Stomach"
    ]

    enum shoulders: [
        "Square", 
        "Normal"
    ]
end
