class Vest < ApplicationRecord
  belongs_to :order

  enum vest_style: [
    'Single Breasted',
    'Double Breasted'
  ]

  enum adjuster_type: %w[
    Button
    Buckle
    None
  ]

  enum lapel_style: [
    'No lapel',
    'Notch',
    'Peak',
    'Shawl'
  ]

  enum fabric: [
    "Back lining",
    "Full fabric"
  ]

  enum side_pocket: {
    "Welt Pocket": 1,
    "No Pocket": 2
  }

  enum vest_model: {
    "Single Breasted 3 Buttons": 1,
    "Single Breasted 4 Buttons": 2,
    "Single Breasted 5 Buttons": 3,
    "Double Breasted 4 on 2 Buttons": 4,
    "Double Breasted 6 on 2 Buttons": 5, 
    "Double Breasted 6 on 3 Buttons": 6
  }

  validates :quantity, presence: { message: 'cannot be blank' },
      numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_consumption, :side_pocket, :chest_pocket, :vest_length, :back_width,
      :chest, :waist, :hips, :vest_model, :lapel_style, :adjuster_type, :remarks, presence: true
end
