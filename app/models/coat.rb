class Coat < ApplicationRecord
    belongs_to :order

    enum specs_form: [
        "Coats",
        "Tux Coat",
        "Tail Coat"
    ]

    enum breast: [
        "Single Breasted",
        "Double Breasted"
    ]

    enum stature: [
        "Erect",
        "Stooping Stature", 
        "Prominent Stomach",
        "Stout"
    ]

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

    enum collar_style: [
        "Notch",
        "Peak",
        "Notch Tuxedo",
        "Peaky Shiny",
        "Shawl",
        "Lapel Trimming"
    ]

    enum back: [
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
        "Functional",
        "Covered buttons"
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
end
