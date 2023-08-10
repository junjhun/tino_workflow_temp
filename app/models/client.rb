class Client < ApplicationRecord
    has_many :orders

    enum gender: [
        "Male",
        "Female"
    ]
end
