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
    'PLEATS TOWARDS POCKETS',
    'PLEATS TOWARDS FLY',
    'NO PLEATS',
    'BACK POCKETS'
  ]

  enum pleat_style: [
    'NO PLEAT',
    'SINGLE PLEATS',
    'TWO PLEATS',
    'BOX PLEATS'
  ]

  enum pleats_combined: {
    'None' => 0,
    '1 pleat towards fly' => 1,
    '1 pleat towards pocket' => 2,
    '2 pleats towards fly' => 3,
    '2 pleats towards pocket' => 4,
    'Box pleats' => 5
  }

  #Overlap
  enum strap: {
    'Standard_2.5"_overlap' => 5,
    'Extended_pointed_strap_1_button' => 1,
    'Extended_squared_strap_2_buttons' => 2,
    'Gurkha' => 6,
    'No_overlap' => 0
    }

  #Tightening
  enum waist_area: {
    'Buckle_side_adjusters' => 3,
    'Button_side_adjusters' => 4,
    'Belt loops' => 0,
    'Garterized' => 5
    'None' => 2
  }

  enum closure: %w[
    Zippered
    Button_fly
  ]
    
  #front_pocket
  enum type_of_pocket: {
    'Straight' => 1,
    'Slanted' => 0,
    'Nacido' => 2,
    'None' => 3
  }, _prefix: true

  enum back_pocket: {
    'Jetted both sides' => 1,
    'Jetted right only' => 3,
    'Jetted left only' => 2,
    'None' => 0,
  }, _prefix: true

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




  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_consumption, :specs_form, :control_no, :pleats,
            :fabric_code, :lining_code, :crotch, :outseam, :waist, :seat, :thigh, :knee, :bottom, :back_pocket,
            :strap, :pant_cuffs, :pleat_style, :type_of_pocket, :add_suspender_buttons, :no_of_pleats, :waist_area, :remarks, presence: true

  validates :control_no, numericality: { only_integer: true, message: 'must be a valid number' }, presence: true
end
