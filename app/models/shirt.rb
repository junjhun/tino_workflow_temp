class Shirt < ApplicationRecord
  belongs_to :order

  enum opening: %w[
    Full_Open
    Half_Open
  ]

  enum front_bar: %w[
    With_bar_(standard_placket)
    No_bar_(no_placket)
    Hidden_(concealed_placket)
  ]

  enum front_pleats: %w[
    Full
    Bib
    None
  ], _prefix: true

  enum back_pleats: %w[
    Box_(center)
    Sides
    Norfolk
    None
  ], _prefix: true

  enum front_pocket: %w[
    Round
    Square
    Pointed
    Square_with_pleat
    Wine_Glass
    None
  ], _prefix: true

  enum front_pocket_flap: %w[
    Squared
    Pointed
    Slanted
    Pointed_Curve
  ], _prefix: true

  enum sleeve_length: %w[
    Long
    Short
  ]

  enum hem: %w[
    Straight
    Am-boy
  ]
    
  enum specs_form: %w[
    Shirting
    Barong
    Tux
  ]

  enum cuffs: %w[
    Single_1-button_square
    Single_1-button_angled
    Single_1-button_curve
    Double_French_square
    Double_French_angled
    Double_French_cocktail
    No_cuffs
  ]

  enum pleats: [
    'TWO SIDE PLEAT',
    'CENTER PLEAT',
    'NO PLEAT',
    'BACK POCKETS (Dart Pleats)'
  ]

  enum type_of_button: [
    'Hidden button',
    'Front bar',
    'No Pockets',
    'Button Down ',
    'Not hidden',
    'Button down loop'
  ]

  enum front_placket: [
    'W/BAR (standard-placket)',
    'NO BAR (NO placket)',
    'HIDDEN BUTTON (concealed placket)'
  ], _prefix: :comments

  # enum back_placket: [
  #     "W/BAR (standard-placket)",
  #     "NO BAR (NO placket)",
  #     "HIDDEN BUTTON (concealed placket)"
  # ]

  enum sleeves: [
    'Contrast 1 (full white collar and white cuff)',
    'Contrast 2 (full white collar)',
    'Contrast 3 (inside collar, cuff and)',
    'No contrast'
  ]

  enum pocket: [
    'Round',
    'Agile',
    'Pointed',
    'Square w/ Pleats',
    'w/ squared flaps',
    'w/ pointed flaps',
    'w/ slanted flaps',
    'w/ pointed curve flaps',
    'Wine glass',
    'Without Pocket'
  ]

  enum collar: [
    'Classic/Traditional',
    'Cutaway/Spread Out',
    'Italian/Wider Collar',
    'Button Down',
    'Hidden Button Down',
    'Wing Tip/Tux',
    'Chinese Collar',
    'Semi-spread',
    'Not applicable'
  ]

  enum bottom: [
    'Straight Bottom',
    'American Boy Cut'
  ]

  enum shirting_barong: [
    'SHIRTING',
    'BARONG',
    'TUX SPECS FORM'
  ]

  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_consumption, :specs_form, :control_no, :fabric_label,
            :fabric_code, :lining_code, :remarks, :cuffs, :pleats, :front_placket, :back_placket, :sleeves, :pocket,
            :collar, :bottom, :type_of_button, presence: true
end
