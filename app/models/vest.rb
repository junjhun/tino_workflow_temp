class Vest < ApplicationRecord
    belongs_to :order

    enum vest_style: [
        "Single Breasted",
        "Double Breasted"
    ]

    enum adjuster_type: [
        "Buttons",
        "Buckle"
    ]

    enum lapel_style: [
        "Notch",
        "Peak",
        "Notch Tuxedo",
        "Peaky Shiny",
        "Shawl",
        "Lapel Trimming"
    ]
end
