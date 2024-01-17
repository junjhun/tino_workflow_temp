class Shirt < ApplicationRecord
    belongs_to :order

    enum specs_form: [
        "Shirting",
        "Barong",
        "Tux"
    ]

    enum cuffs: [
        "Single Cuff Curve",
        "Single Cuff Square",
        "Single Cuff Angle Cut",
        "Double Cuff Square",
        "Double Cuff Angle Cut",
        "American Cuff Square",
        "American Cuff Angle Cut"
    ]

    enum pleats: [
        "TWO SIDE PLEAT",
        "CENTER PLEAT",
        "NO PLEAT",
        "BACK POCKETS (Dart Pleats)"
    ]

    enum type_of_button: [
        "Hidden button",
        "Front bar",
        "No Pockets",
        "Button Down ",
        "Not hidden",
        "Button down loop"
    ]

    enum front_placket: [
        "W/BAR (standard-placket)",
        "NO BAR (NO placket)",
        "HIDDEN BUTTON (concealed placket)"
    ], _prefix: :comments

    # enum back_placket: [
    #     "W/BAR (standard-placket)",
    #     "NO BAR (NO placket)",
    #     "HIDDEN BUTTON (concealed placket)"
    # ]

    enum sleeves: [
        "Contrast 1 (full white collar and white cuff)",
        "Contrast 2 (full white collar)",
        "Contrast 3 (inside collar, cuff and)"
    ]

    enum pocket: [
        "Round",
        "Agile",
        "Pointed",
        "Square w/ Pleats",
        "w/ squared flaps",
        "w/ ponted flaps",
        "w/ slanted flaps",
        "w/ pointed curve flaps",
        "Wine glass"
    ]

    enum collar: [
        "Classic/Traditional",
        "Cutaway/Spread Out",
        "Italian/Wider Collar",
        "Button Down",
        "Hidden Button Down",
        "Wing Tip/Tux",
        "Chinese Collar"
    ]

    enum bottom: [
        "Straight Bottom",
        "American Boy Cut"
    ]

    enum shirting_barong: [
        "SHIRTING",
        "BARONG",
        "TUX SPECS FORM"
    ]
end
