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

  enum sleeves_and_padding: { # shoulder
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

  enum boutonniere: { #lapel buttonhole
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

  def coat_style_image_asset_path
    return nil if style.blank? # Handle blank values

    case style
      when "Single-breasted 1 button"
        "coat/style/Single-breasted_1B.png"
      when "Single-breasted 2 buttons"
        "coat/style/Single-breasted_2B.png"
      when "Single-breasted 3 buttons"
        "coat/style/Single-breasted_3B.png"
      when 'Single-breasted 3-on-2 buttons'
        "coat/style/Single-breasted_3-on-2B.png"
      when 'Double-breasted 4-on-1 buttons'
        "coat/style/Double-breasted_4-on-1B.png"
      when 'Double-breasted 4-on-2 buttons'
        "coat/style/Double-breasted_4-on-2B.png"
      when 'Double-breasted 6-on-1 buttons'
        "coat/style/Double-breasted_6-on-1B.png"
      when 'Double-breasted 6-on-2 buttons'
        "coat/style/Double-breasted_6-on-2B.png"
      else
        "x.png" # Fallback image
    end
  end

  def coat_lapel_style_image_asset_path
    return nil if lapel_style.blank? # Handle blank values

    case lapel_style
      when "Notch"
        "coat/lapel/Notch.png"
      when "Peak"
        "coat/lapel/Peak.png"
      when "Shawl"
        "coat/lapel/Shawl.png"
      else
        "x.png" # Fallback image
    end
  end

  def coat_vent_image_asset_path
    return nil if vent.blank? # Handle blank values

    case vent
      when "No Vent"
        "x.png"
      when "1 vent (center)"
        "coat/vent/Center_Vent.png"
      when "2 vents (side)"
        "coat/vent/Side_Vent.png"
      else
        "x.png" # Fallback image
    end
  end

  def coat_lining_image_asset_path
    return nil if lining.blank? # Handle blank values

    case lining
      when "Unlined(none)"
        "coat/lining/Unlined.png"
      when "Half_Lining"
        "coat/lining/Half_Lining.png"
      when "Full_Lining"
        "coat/lining/Full_Lining.png"
      when "Quarter_Lining"
        "coat/lining/Quarter_Lining.png"
      else
        "x.png" # Fallback image
    end
  end

  def coat_chest_pocket_image_asset_path
    return nil if pocket_type.blank? # Handle blank values

    case pocket_type
      when "Patch"
        "coat/chest_pocket/Patch.png"
      when "Straight"
        "coat/chest_pocket/Straight.png"
      when "Barchetta"
        "coat/chest_pocket/Barchetta.png"
      when "None"
        "coat/chest_pocket/No_Chest_Pocket.png"
      else
        "x.png" # Fallback image
    end
  end

  def coat_side_pocket_image_asset_path
    return nil if front_side_pocket.blank? # Handle blank values

    if side_pockets_flap # Check if the flap boolean is true
      case front_side_pocket
        when "Jetted"
          "coat/side_pockets/Jetted_w_Flap.png"
        when "Patch"
          "coat/side_pockets/Patch_w_Flap.png"
        else
          "coat/side_pockets/None.png" # Fallback for specific flap cases
      end
    else # No flap
      case front_side_pocket
        when "Jetted"
          "coat/side_pockets/Jetted_w_o_Flap.png"
        when "Patch"
          "coat/side_pockets/Patch_w_o_Flap.png"
        else
          "coat/side_pockets/None.png" # Fallback for specific no-flap cases
      end
    end
  end

  def coat_button_spacing_image_asset_path
    return nil if button_spacing.blank? # Handle blank values

    case button_spacing
      when "Stacking"
        "coat/sleeve_button/Stacking.png"
      when "Kissing"
        "coat/sleeve_button/Kissing.png"
      else
        "x.png" # Fallback image
    end
  end

  def coat_boutonniere_image_asset_path
    return nil if boutonniere.blank? # Handle blank values

    case boutonniere
      when "1 Boutonniere", "1 Milanese"
        "coat/lapel_buttonhole/1_Boutonniere_Milanese.png"
      when "2 Boutonniere", "2 Milanese"
        "coat/lapel_buttonhole/2_Boutonniere_Milanese.png"
      else
        "x.png" # Fallback image
    end
  end

  def coat_shoulder_padding_image_asset_path
    return nil if sleeves_and_padding.blank? # Handle blank values

    case sleeves_and_padding
      when /Regular shoulders/ # Using regex for partial match
        "coat/shoulder/Regular_Shoulder.png"
      when /Spalla-camicia/ # Using regex for partial match
        "coat/shoulder/Spalla_Camicia.png"
      when "Conrolino"
        "coat/shoulder/Conrolino.png"
      else
        "x.png" # Fallback image
    end
  end

  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_code, :lining_code, :fabric_consumption, :jacket_length, :back_width, :sleeves, :cuffs_1, :cuffs_2, :back_width, :sleeves, :collar, :chest, :waist, :stature, :shoulders, :style, :lapel_style, :lapel_width, :vent, :sleeves_and_padding, :lining, :sleeve_buttons, :button_spacing, :button, :no_of_buttons, :color_of_sleeve_buttons, :boutonniere, :lapel_buttonhole_thread_color, :pocket_type, :front_side_pocket, :side_pocket_placement, :hips, presence: { message: 'cannot be blank' }

  validates :no_of_buttons, numericality: { only_integer: true, message: 'must be a valid number' }, presence: true

  validates :monogram_placement, :monogram_font, :monogram_thread_color, presence: { message: 'cannot be blank' }, if: :monogram_initials?
end
