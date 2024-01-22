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

    enum pleat_style: [
        "NO PLEAT",
        "SINGLE PLEATS",
        "TWO PLEATS",
        "BOX PLEATS"
    ]

    enum type_of_pocket: [
        "SLANTED POCKET",
        "STRAIGHT POCKET",
        "NACIDO POCKET"
    ]

    enum back_pocket: [
        "No Back Pocket",
        "2 Back Pocket",
        "1 left Back Pocket",
        "1 right Back Pocket",
        "Pockets with Button?",
        "Pockets with Flap"
    ]

    enum pant_cuffs: [
        "No pant cuffs",
        "With pant cuffs",
        "Slanting Bottom"
    ]

    enum strap: [
        "No overlap / no extended strap",
        "Extended Overlap / Pointed Strap / 1 Button",
        "Extended Overlap / Squared Strap / 2 Button",
        "Thick waistband",
        "Other Design"
    ]

    validate :check_quantity

    def check_quantity
        errors.add(:base, "Quantity cannot be less than one") if self.quantity < 1
    end
end
