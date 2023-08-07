class Pant < ApplicationRecord
    belongs_to :order

    enum pleats: [
        "PLEATS TOWARDS POCKETS",
        "PLEATS TOWARDS FLY",
        "NO PLEATS",
        "BACK POCKETS"
    ]
end
