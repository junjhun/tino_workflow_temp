class Shirt < ApplicationRecord
    belongs_to :order

    enum cuffs: [
        "number of buttons, SAFARI SLEEVES",
        "HOW MANY BUTTON?, COAT SLEEVES",
        "SINGLE CUFFS (1 button round)",
        "SINGLE CUFFS (1 button angle)",
        "DOUBLE CUFFS (french square)",
        "DOUBLE CUFFS (french angle)",
        "DOUBLE CUFFS (Cocktail)"
    ]

    enum pleats: [
        "TWO SIDE PLEAT",
        "CENTER PLEAT",
        "NO PLEAT",
        "BACK POCKETS (Dart Pleats)"
    ]

    enum placket: [
        "W/BAR (standard-placket)",
        "NO BAR (NO placket)",
        "HIDDEN BUTTON (concealed placker)"
    ]

    enum sleeves: [
        "Contrast 1 (full white collar and white cuff)",
        "Contrast 2 (full white collar)"
    ]

    enum pocket: [
        "Round",
        "Agle",
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
        "Round Bottom"
    ]

    enum shirting_barong: [
        "SHIRTING",
        "BARONG",
        "TUX SPECS FORM"
    ]
end
