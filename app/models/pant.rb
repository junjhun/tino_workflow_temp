class Pant < ApplicationRecord
  belongs_to :order


  enum rise: %w[
    Mid
    High
    Low
  ]

  enum cut: %w[
    Straight
    Wide
    Tapered
  ]

  enum pleats: [
    '2 PLEATS TOWARDS POCKETS',
    '2 PLEATS TOWARDS FLY',
    'NO PLEATS',
    'BACK POCKETS',
    '1 PLEAT TOWARDS POCKETS',
    '1 PLEAT TOWARDS FLY',
    'BOX PLEATS'
  ]

 enum overlap: %w[
    Standard_2.5"_overlap
    Extended_pointed_strap_1_button
    Extended_squared_strap_2_buttons
    Gurkha
    No_overlap
    ]

  # waist_area = 0=Belt loop, 1=Side Adjuster, 2=no belt loop/ no side adjuster
  enum waist_area: [
    'Belt loops',
    'Side Adjuster',
    'no belt loop/ no side adjuster',
    'Buckle_side_adjusters',
    'Button_side_adjusters',
    'Garterized'
  ]

  enum closure: %w[
    Zippered
    Button_fly
  ]
    
  # type_of_pocket = 0=SLANTED POCKET, 1=STRAIGHT POCKET, 2=NACIDO POCKET
  enum type_of_pocket: [
    'Slanted',
    'Straight Pocket',
    'Nacido',
    'None'
  ]

  enum back_pocket: [
    'No Back Pocket',
    '2 Back Pocket',
    '1 left Back Pocket',
    '1 right Back Pocket',
    'Pockets with Button?',
    'Pockets with Flap',
    'Jetted both sides',
    'Jetted right only',
    'Jetted left only'
  ]

  # specs_form = 0=Pants, 1=Tux Pants
  # enum specs_form: [
  #   'Pants',
  #   'Tux Pants'
  # ]



  # back_pocket = 0=NO BACK POCKET, 1=2 BACK POCKET, 2=1 left Back Pocket, 3=1 right Back Pocket, 4=Pockets with Button?, 5=Pockets with Flap


  # pant_cuffs = 0=No pant cuffs, 1=With pant cuffs, 2=Slanting Bottom
  # enum pant_cuffs: [
  #   'No pant cuffs',
  #   'With pant cuffs',
  #   'Slanting Bottom'
  # ]

  # strap = 0=No overlap / no extended strap, 1=Extended Overlap / Pointed Strap / 1 Button, 2=Extended Overlap / Squared Strap / 2 Button, 3=Thick waistband, 4=Other Design
  # enum strap: [
  #   'No overlap / no extended strap',
  #   'Extended Overlap / Pointed Strap / 1 Button',
  #   'Extended Overlap / Squared Strap / 2 Button',
  #   'Thick waistband',
  #   'Other Design'
  # ]



  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_consumption, :specs_form, :control_no, :pleats, :fabric_label,
            :fabric_code, :lining_code, :crotch, :outseam, :waist, :seat, :thigh, :knee, :bottom, :back_pocket,
            :strap, :pant_cuffs, :pleat_style, :type_of_pocket, :add_suspender_buttons, :no_of_pleats, :waist_area, :remarks, presence: true

  validates :control_no, numericality: { only_integer: true, message: 'must be a valid number' }, presence: true
end
