class Coat < ApplicationRecord
  belongs_to :order

  
  enum lapel_style: {
    'Notch' => 0,
    'Peak' => 1,
    'Shawl' => 4
  }, _prefix: true

  enum vent: [
    'No Vent',
    '1 vent (center)',
    '2 vents (side)'
  ],  _prefix: true

  enum sleeves_and_padding: {
    'Regular shoulders - regular padding' => 5,
    'Regular shoulders - thin padding' => 1,
    'Spalla-camicia - shirred' => 2,
    'Spalla-camicia - minimal shirring' => 6,
    'Spalla-camicia - not shirred' => 3,
    'Conrolino' => 4
  }

  enum lining: %w[
    Unlined(none)
    Half_Lining
    Full_Lining
    Quarter_Lining
  ]

  enum sleeve_buttons: {
    'All Functional' => 1,
    '2 Fake 2 Functional' => 2,
    'All Fake' => 0,
    'None' => 3
  }, _prefix: true

  # Sleeve Button
  enum button_spacing: %w[
    Stacking
    Kissing
  ]

  enum button: {
    'Horn' => 1,
    'Brass' => 2,
    'Covered' => 3
  }

  enum boutonniere: {
    '1 Boutonniere' => 2,
    '2 Boutonniere' => 1,
    '1 Milanese' => 4,
    '2 Milanese' => 5,
    'No boutonniere' => 0
  }

  enum pocket_type: { #chest pocket
    'Straight' => 1,
    'Barchetta' => 0,
    'Patch' => 2,
    'None' => 4
  }

  enum front_side_pocket: {
    'Jetted' => 7,
    'Patch' => 3,
    'None' => 0
  }, _prefix: true

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

  enum style: {
    'Single-breasted 1 button' => 0,
    'Single-breasted 2 buttons' => 1,
    'Single-breasted 3-on-2 buttons' => 6,
    'Single-breasted 3 buttons' => 2,
    'Double-breasted 4-on-1 buttons' => 7,
    'Double-breasted 4-on-2 buttons' => 8,
    'Double-breasted 6-on-1 buttons' => 9,
    'Double-breasted 6-on-2 buttons' => 10
  }
  
  enum vent: [
    'No Vent',
    '1 vent (center)',
    '2 vents (side)'
  ]

  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_code, :lining_code, :fabric_consumption, :jacket_length, :back_width, :sleeves, :cuffs_1, :cuffs_2, :back_width, :sleeves, :collar, :chest, :waist, :stature, :shoulders, :style, :lapel_style, :lapel_width, :vent, :sleeves_and_padding, :lining, :sleeve_buttons, :button_spacing, :button, :no_of_buttons, :color_of_sleeve_buttons, :boutonniere, :lapel_buttonhole_thread_color, :pocket_type, :front_side_pocket, :side_pocket_placement, :monogram_initials, :monogram_placement, :monogram_font, :monogram_thread_color, :hips, presence: { message: 'cannot be blank' }

  validates :no_of_buttons, numericality: { only_integer: true, message: 'must be a valid number' }, presence: true
end
