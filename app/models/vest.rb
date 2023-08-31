class Vest < ApplicationRecord
    belongs_to :order

    enum vest_style: [
        "Single Breasted",
        "Double Breasted"
    ]
end
