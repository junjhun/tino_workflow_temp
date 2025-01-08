class AddItem < ApplicationRecord
  belongs_to :orders

  enum item_type: %w[
    Coat
    Skirt
    test
  ]
end
