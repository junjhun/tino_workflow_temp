class Shirt < ApplicationRecord
  belongs_to :order

  enum opening: %w[
    Full_Open
    Half_Open
  ]

  enum front_placket: [
    'With_bar_(standard_placket)',
    'No_bar_(no_placket)',
    'Hidden_(concealed_placket)'
  ], _prefix: :true

  enum front_pleats: %w[
    Full
    Bib
    None
  ], _prefix: true

  enum back_pleats: %w[
    Box_(center)
    Sides
    Norfolk
    None
  ], _prefix: true

  enum pocket: {
    'Round'=> 0,
    'Square'=> 1,
    'Pointed'=> 2,
    'Square w/ Pleat'=> 3,
    'Wine glass'=> 8,
    'None'=> 9,
  }, _prefix: true

  enum front_pocket_flap: %w[
    Squared
    Pointed
    Slanted
    Pointed_Curve
    None
  ], _prefix: true

  enum sleeve_length: %w[
    Long
    Short
  ]

  enum cuffs: %w[
    Single_1-button_round
    Single_1-button_angle
    Single_1-button_square
    Double_French_square
    Double_French_angled
    Double_French_curve
    No_cuffs
  ]

  enum collar_style: {
    'Traditional'=> 0,
    'Spread'=> 1,
    'Semi-spread'=> 7,
    'Wide(Italian)'=> 2,
    'Wing'=> 5,
    'Chinese'=> 6,
    'Nehru'=> 9,
    'No_collar'=> 8
  }
    
  
  enum bottom: [
    'Straight',
    'Am-Boy'
  ]

  #  updated to contrast
  enum sleeves: {
    'Contrast 1 (full collar and full cuff)' => 0,
    'Contrast 2 (full collar only)' => 1,
    'Contrast 3 (inside collar and cuff)' => 2,
    'No Contrast' => 3,
    'Others' => 4
  }
    
  enum monogram_placement: %w[
    Back_of_Collar
    Left_Chest
    Right_Chest
    Left_Waist
    Right_Waist
    Left_Hem
    Right_Hem
    Left_Sleeve_Cuff
    Right_Sleeve_Cuff
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

  enum monogram_font: [
    'Galant',
    'Script',
    'Others'
  ],_prefix: true

  def collar_style_image_asset_path
    return nil if collar_style.blank? # Handle blank values

    case collar_style
      when "Traditional"
        if buttoned_down
          "shirt/collar/Button_Down.png"
        elsif buttoned_down_with_loop
          "shirt/collar/Hidden_Button_Down.png"
        else
          "shirt/collar/Traditional.png"
      end
      when "Spread"
        "shirt/collar/Spread.png"
      when "Wide(Italian)"
        "shirt/collar/Wide_(Italian).png"
      when "Wing"
        "shirt/collar/Wing.png"
      when "Chinese"
        "shirt/collar/Chinese.png"
      when "Semi-spread"
        "shirt/collar/Semi-spread.png"
      when "Nehru"
        "shirt/collar/Nehru.png"
      else
        "x.png" # Fallback image
    end
  end

  def sleeves_image_asset_path
    return nil if sleeves.blank? # Handle blank values

    case sleeves
      when /^Contrast 1/
        "shirt/contrast/Contrast_1.png"
      when /^Contrast 2/
        "shirt/contrast/Contrast_2.png"
      when /^Contrast 3/
        "shirt/contrast/Contrast_3.png"
      else
        "x.png" # Fallback image
    end
  end

  def cuffs_image_asset_path
    return nil if cuffs.blank? # Handle blank values

    case cuffs
      when "Single_1-button_curve", "Single_1-button_round"
        "shirt/cuffs/Single1_button_curve.png"
      when "Single_1-button_angle"
        "shirt/cuffs/Single1_button_angled.png"
      when "Single_1-button_square"
        "shirt/cuffs/Single1_button_square.png"
      when "Double_French_square"
        "shirt/cuffs/Double_French_square.png"
      when "Double_French_angled"
        "shirt/cuffs/Double_French_angled.png"
      when "Double_French_curve"
        "shirt/cuffs/Double_French_curve.png"
    else
      "x.png" # Fallback image
    end
  end

  def pocket_image_asset_path
    return nil if pocket.blank? # Handle blank values

    case pocket
      when "Round"
        "shirt/pocket/Round_Pocket.png"
      when "Pointed"
        "shirt/pocket/Pointed_Pocket.png"
      when "Square w/ Pleats"
        "shirt/pocket/Square_wPleat_Pocket.png"
      when "Wine glass"
        "shirt/pocket/Wine_Glass_Pocket.png"
      when "Square", "Agile"
        "shirt/pocket/Square_Pocket.png"
      else
        "x.png" # Fallback image
    end
  end



  validates :quantity, presence: { message: 'cannot be blank' },
                       numericality: { only_integer: true, greater_than: 0, message: 'must be a positive integer' }

  validates :fabric_code, :lining_code, :fabric_consumption, :shirt_length, :back_width, :sleeve, :right_cuff, :left_cuff, :chest, :shirt_waist, :stature, :shoulders, :opening, :front_placket, :no_of_studs, :front_pleats, :back_pleats, :pocket, :front_pocket_flap, :sleeve_length, :cuffs, :collar_style, :collar, :bottom, :sleeves, :contrast_placement, :hips, presence: true

  validates :monogram_placement, :monogram_font, :monogram_color, presence: { message: 'cannot be blank' }, if: :monogram_initials?

end
