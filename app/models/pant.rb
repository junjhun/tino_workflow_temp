class Pant < ApplicationRecord
    belongs_to :order

    enum specs_form: [
        "Pants",
        "Tux Pants"
    ]

    enum pleats: [
        "PLEATS TOWARDS POCKETS",
        "PLEATS TOWARDS FLY",
        "NO PLEATS",
        "BACK POCKETS"
    ]
end
