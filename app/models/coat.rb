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

    validates :quantity, presence: { message: "cannot be blank" }, 
    numericality: { only_integer: true, greater_than: 0, message: "must be a positive integer" }


    validates :fabric_consumption, :specs_form, :control_no, :breast, :jacket_length, 
    :back_width, :sleeves, :cuffs_1, :cuffs_2, :collar, :chest, :waist, :hips, 
    :stature, :shoulders, :pocket_type, :front_side_pocket, :remarks, :fabric_code, 
    :lining_code, :fabric_label, :style, :lapel_style, :vent, :lining, :sleeves_and_padding, 
    :button, :sleeve_buttons, :no_of_buttons, :boutonniere, :boutonniere_color, 
    :boutonniere_thread_code, :button_spacing, :coat_pockets, presence: { message: "cannot be blank" }

    validates :no_of_buttons, numericality: { only_integer: true, message: "must be a valid number" }, presence: true

end
