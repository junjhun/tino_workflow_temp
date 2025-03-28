class Coat < ApplicationRecord
  belongs_to :order

  
  enum lapel_style: [
    'Notch',
    'Peak',
    'Notch Tuxedo',
    'Peaky Shiny',
    'Shawl',
    'Lapel Trimming'
  ],  _prefix: true

  enum vent: [
    'No Vent',
    '1 vent (center)',
    '2 vents (side)'
  ],  _prefix: true

  enum sleeves_and_padding: [
    'House cut',
    'Regular shoulders - thin padding',
    'Spalla-camicia - minimal shirring',
    'Spalla-camicia - not shirred',
    'Conrolino',
    'Regular shoulders - regular padding',
    'Spalla-camicia - shirred'
  ]

  enum lining: %w[
    Unlined_none)
    Half_Lining
    Full_Lining
    Quarter_Lining
  ]

  enum sleeve_buttons: [
    'All Fake',
    'All Functional',
    '2 Fake 2 Functional',
    'None'
  ],  _prefix: true

  enum button_spacing: %w[
    Stacking
    kissing
  ]

  enum button: [
    'Regular Button',
    'Horn',
    'Brass',
    'Covered'
  ]

  enum boutonniere: [
    'No boutonniere',
    '2 Boutonniere',
    'Regular',
    'w/ flower holder',
    '1 Milanese',
    '1 Boutonniere',
    '2 Milanese'
  ]

  enum pocket_type: [
    'Curved Chest Pocket',
    'Flat Chest Pocket',
    'Patch',
    'Satin on Chest Pocket',
    'Straight',
    'Barchetta',
    'None'
  ]

  enum front_side_pocket: [
    'NoPocket',
    '2 Pockets',
    '3 Pockets (w/ticket pocket)',
    'Patch',
    'Pockets with flaps?',
    'Hacking/Italian Pocket?',
    'Satin on Pockets Trimming',
    'Jetted'
  ], _prefix: true

  enum side_pocket_placement: %w[
    Right_only
    Left_only
    Both_sides
  ]
  enum monogram_placement: %w[
    Under_Collar
    Inner_Lining_Chest_Pocket
    Left_Sleeve_Cuff
    Right_Sleeve_Cuff
    Others
  ],  _prefix: true

  enum monogram_font: [
    'Galant',
    'Script',
    'Others'
  ]

  enum specs_form: [
    'Coats',
    'Tux Coat',
    'Tail Coat'
  ]

  

  enum breast: [
    'Single Breasted',
    'Double Breasted'
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

  enum style: [
    'Single-breasted 1 button',
    'Single-breasted 2 buttons',
    'Single-breasted 3 buttons',
    'Single 4 button',
    'Double 4 button',
    'Double 6 button',
    'Single-breasted 3-on-2 buttons',
    'Double-breasted 4-on-1 buttons',
    'Double-breasted 4-on-2 buttons',
    'Double-breasted 6-on-1 buttons',
    'Double-breasted 6-on-2 buttons'
  ]
  
  enum vent: [
    'No Vent',
    '1 vent (center)',
    '2 vents (side)'
  ]

 


  





  



  


  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_consumption, :specs_form, :control_no, :breast, :jacket_length,
            :back_width, :sleeves, :cuffs_1, :cuffs_2, :collar, :chest, :waist, :hips,
            :stature, :shoulders, :pocket_type, :front_side_pocket, :remarks, :fabric_code,
            :lining_code, :fabric_label, :style, :lapel_style, :vent, :lining, :sleeves_and_padding,
            :button, :sleeve_buttons, :no_of_buttons, :boutonniere, :boutonniere_color,
            :boutonniere_thread_code, :button_spacing, :coat_pockets, presence: { message: 'cannot be blank' }

  validates :no_of_buttons, numericality: { only_integer: true, message: 'must be a valid number' }, presence: true
end
