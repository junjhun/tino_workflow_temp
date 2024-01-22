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
        "Lapel Trimming",
        "No lapel"
    ]

    validate :check_quantity

    def check_quantity
        errors.add(:base, "Quantity cannot be less than one") if self.quantity < 1
    end
end
