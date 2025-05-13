class Shirt < ApplicationRecord
  belongs_to :order

  enum opening: %w[
    Full_Open
    Half_Open
  ]

  enum front_placket: [
    'With_bar_(standard_placket)',
    'No_bar_(no_placket)',
    'Hidden_(concealed_placket)'
  ], _prefix: :true

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

  enum pocket: {
    'Round'=> 0,
    'Square'=> 1,
    'Pointed'=> 2,
    'Square w/ Pleat'=> 3,
    'Wine glass'=> 8,
    'None'=> 9,
  }, _prefix: true

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

  enum cuffs: %w[
    Single_1-button_round
    Single_1-button_angle
    Single_1-button_square
    Double_French_square
    Double_French_angled
    Double_French_curve
    No_cuffs
  ]

  enum collar: {
    'Traditional'=> 0,
    'Spread'=> 1,
    'Semi-spread'=> 7,
    'Wide(Italian)'=> 2,
    'Wing'=> 5,
    'Chinese'=> 6,
    'Nehru'=> 9,
    'No_collar'=> 8
  }
    
  
  enum bottom: [
    'Straight',
    'Am-Boy'
  ]

  #  updated to contrast
  enum sleeves: {
    'Contrast 1 (full collar and full cuff)' => 0,
    'Contrast 2 (full collar only)' => 1,
    'Contrast 3 (inside collar and cuff)' => 2,
    'No Contrast' => 3,
    'Others' => 4
  }
    
  enum monogram_placement: %w[
    Back_of_Collar
    Left_Chest
    Right_Chest
    Left_Waist
    Right_Waist
    Left_Hem
    Right_Hem
    Left_Sleeve_Cuff
    Right_Sleeve_Cuff
  ]

  enum stature: [
    'Erect',
    'Stooping Stature',
    'Prominent Stomach',
    'Stout',
    'Normal'
  ], _prefix: :comments

  enum shoulders: [
    'Stooping Shoulders',
    'Square',
    'Normal'
  ]

  enum monogram_font: [
    'Galant',
    'Script',
    'Others'
  ],_prefix: true
  
  # enum specs_form: %w[
  #   Shirting
  #   Barong
  #   Tux
  # ]

  

  # enum pleats: [
  #   'TWO SIDE PLEAT',
  #   'CENTER PLEAT',
  #   'NO PLEAT',
  #   'BACK POCKETS (Dart Pleats)'
  # ]

  # enum type_of_button: [
  #   'Hidden button',
  #   'Front bar',
  #   'No Pockets',
  #   'Button Down ',
  #   'Not hidden',
  #   'Button down loop'
  # ]



  # enum back_placket: [
  #     "W/BAR (standard-placket)",
  #     "NO BAR (NO placket)",
  #     "HIDDEN BUTTON (concealed placket)"
  # ]

  # enum sleeves: [
  #   'Contrast 1 (full white collar and white cuff)',
  #   'Contrast 2 (full white collar)',
  #   'Contrast 3 (inside collar, cuff and)',
  #   'No contrast'
  # ]

  # enum pocket: [
  #   'Round',
  #   'Agile',
  #   'Pointed',
  #   'Square w/ Pleats',
  #   'w/ squared flaps',
  #   'w/ pointed flaps',
  #   'w/ slanted flaps',
  #   'w/ pointed curve flaps',
  #   'Wine glass',
  #   'Without Pocket'
  # ]




  # enum shirting_barong: [
  #   'SHIRTING',
  #   'BARONG',
  #   'TUX SPECS FORM'
  # ]

  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_consumption, :control_no,
            :fabric_code, :lining_code, :remarks, :cuffs, :pleats, :front_placket, :back_placket, :sleeves, :pocket,
            :collar, :bottom, :type_of_button, presence: true
end
