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

    enum waist_area: [
        "Belt loop",
        "Side Adjuster",
        "no belt loop/ no side adjuster"
    ]

    validates :quantity, presence: { message: "cannot be blank" }, 
    numericality: { only_integer: true, greater_than: 0, message: "must be a positive integer" }

    validates :fabric_consumption, :specs_form, :control_no, :pleats, :fabric_label, 
    :fabric_code, :lining_code, :crotch, :outseam, :waist, :seat, :thigh, :knee, :bottom, :back_pocket, 
    :strap, :pant_cuffs, :pleat_style, :type_of_pocket, :add_suspender_buttons, :no_of_pleats, :waist_area, :remarks, presence: true

    validates :control_no, numericality: { only_integer: true, message: "must be a valid number" }, presence: true
end
