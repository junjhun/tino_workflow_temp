class Coat < ApplicationRecord
    belongs_to :order

    enum specs_form: [
        "Coats",
        "Tux Coat",
        "Tail Coat"
    ]

    enum pocket_type: [
        "Curved Chest Pocket",
        "Flat Chest Pocket",
        "Chest Patch Pocket",
        "Satin on Chest Pocket"  
    ]

    enum breast: [
        "Single Breasted",
        "Double Breasted"
    ]

    enum stature: [
        "Erect",
        "Stooping Stature", 
        "Prominent Stomach",
        "Stout",
        "Normal"
    ], _prefix: :comments

    enum shoulders: [
        "Stooping Shoulders",
        "Square", 
        "Normal"
    ]

    enum style: [
        "Single 1 button",
        "Single 2 button",
        "Single 3 button",
        "Single 4 button",
        "Double 4 button",
        "Double 6 button"
    ]

    enum lapel_style: [
        "Notch",
        "Peak",
        "Notch Tuxedo",
        "Peaky Shiny",
        "Shawl",
        "Lapel Trimming"
    ]

    enum vent: [
        "No Vent",
        "Center Vent",
        "Double Vent"
    ]

    enum lining: [
        "Unlined",
        "Half-lined",
        "Fully-Lined"
    ]

    enum sleeves_and_padding: [
        "House cut",
        "Thin Padding",
        "Spalla Camicia/ With shirring / no padding",
        "Spalla Camicia/ no shirring / no padding",
        "Conrolino / rope shoulder"
    ]

    enum button: [
        "Regular Button",
        "Horned",
        "Brass",
        "Covered"
    ]

    enum sleeve_buttons: [
        "Fake",
        "Functional / Surgeons",
        "2 Fake 2 Functional",
        "No Ohales"
    ]

    enum boutonniere: [
        "No boutonniere",
        "Double boutonniere",
        "Regular",
        "w/ flower holder",
        "Milanese"
    ]

    enum button_spacing: [
        "Stacking",
        "kissing"
    ]

    enum front_side_pocket: [
        "No Pocket",
        "2 Pockets",
        "3 Pockets (w/ticket pocket)",
        "2 Patch Pockets",
        "Pockets with flaps?",
        "Hacking/Italian Pocket?",
        "Satin on Pockets Trimming"
    ]

    validate :check_quantity

    def check_quantity
        errors.add(:base, "Quantity cannot be less than one") if self.quantity < 1
    end
end
