class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  enum role: [ "Administrator", "Master Tailor", "Sales Assistant", "Production Manager", "Coat Maker", "Pants Maker", "Shirt Maker", "Vest Maker"]
end
