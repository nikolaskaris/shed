class Gear < ApplicationRecord
  belongs_to :user
  has_many   :photos

  validates :activity, presence: true
  validates :gear_type, presence: true
  validates :size, presence: true
  validates :listing_name, presence: true, length: { maximum: 50 }
  validates :summary, presence: true, length: { maximum: 500 }
  validates :location, presence: true
end
