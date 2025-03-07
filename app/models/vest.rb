class Vest < ApplicationRecord
  belongs_to :order

  enum vest_style: [
    'Single Breasted',
    'Double Breasted'
  ]

  enum adjuster_type: %w[
    Buttons
    Buckle
  ]

  enum lapel_style: [
    'No lapel',
    'Notch',
    'Peak',
    'Shawl'
  ]

  enum vest_model: {
    Single_breasted_3_buttons: 1,
    Single_breasted_4_buttons: 2,
    Single_breasted_5_buttons: 3,
    Double_breasted_4_on_2_buttons: 4,
    Double_breasted_6_on_2_buttons: 5, 
    Double_breasted_6_on_3_buttons: 6
  }

  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_consumption, :side_pocket, :chest_pocket, :vest_length, :back_width,
            :chest, :waist, :hips, :vest_style, :lapel_style, :adjuster_type, :number_of_front_buttons, :remarks, presence: true
end
