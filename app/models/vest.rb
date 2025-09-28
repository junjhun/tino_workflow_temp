class Vest < ApplicationRecord
  belongs_to :order
  
  #vest_model
  enum vest_style: {
    "Single Breasted 2 Buttons" => 0,
    "Single Breasted 3 Buttons" => 2,
    "Single Breasted 4 Buttons"=> 3,
    "Single Breasted 5 Buttons"=> 4,
    "Double Breasted 4 on 2 Buttons" => 1,
    "Double Breasted 6 on 2 Buttons" => 5, 
    "Double Breasted 6 on 3 Buttons "=> 6
 }

  enum adjuster_type: %w[
    Button
    Buckle
    None
  ]

  enum lapel_style: {
    'No lapel'=> 6,
    'Notch'=> 0,
    'Peak'=> 1,
    'Shawl'=> 4
  }

  enum fabric: [
    "Back lining",
    "Full fabric"
  ]

  enum side_pocket: [
    "Welt Pocket",
    "No Pocket"
  ]
  
  validates :quantity, presence: { message: 'cannot be blank' },
      numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_code, :lining_code, :fabric_consumption, :vest_length, :back_width, :chest, :waist, :hips, :vest_style, :lapel_style, :lapel_width, :fabric, :adjuster_type, :chest_pocket, :side_pocket, presence: true
end
