class Review < ApplicationRecord
  belongs_to :gear
  belongs_to :reservation
  belongs_to :borrower
  belongs_to :owner
end
