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

    validates :quantity, presence: { message: "cannot be blank" }, 
    numericality: { only_integer: true, greater_than: 0, message: "must be a positive integer" }

    validates :fabric_consumption, :side_pocket, :chest_pocket, :vest_length, :back_width, 
    :chest, :waist, :hips, :vest_style, :lapel_style, :adjuster_type, :number_of_front_buttons, :remarks, presence: true
end
