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

  enum pocket_type: {
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
    'Single-breasted 3-on-2 buttons' => 3,
    'Single-breasted 3 buttons' => 2,
    'Double-breasted 4-on-1 buttons' => 4,
    'Double-breasted 4-on-2 buttons' => 5,
    'Double-breasted 6-on-1 buttons' => 6,
    'Double-breasted 6-on-2 buttons' => 7
  }
  
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
            :lining_code, :style, :lapel_style, :vent, :lining, :sleeves_and_padding,
            :button, :sleeve_buttons, :no_of_buttons, :boutonniere, :boutonniere_color,
            :boutonniere_thread_code, :button_spacing, :coat_pockets, presence: { message: 'cannot be blank' }

  validates :no_of_buttons, numericality: { only_integer: true, message: 'must be a valid number' }, presence: true
end
