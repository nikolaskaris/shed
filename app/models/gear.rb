class Gear < ApplicationRecord
  belongs_to :user
  has_many   :photos
  has_many   :reservations
  has_many   :reviews

  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  validates :activity, presence: true
  validates :gear_type, presence: true
  validates :size, presence: true
  validates :listing_name, presence: true, length: { maximum: 50 }
  validates :summary, presence: true, length: { maximum: 2000 }
  validates :location, presence: true
  validates :price, presence: true, numericality: true

  def cover_photo(size)
    if self.photos.length > 0
      self.photos[0].image.url(size)
    else
      "blank.jpg"
    end
  end

  def average_rating
    reviews.count == 0 ? 0 : reviews.average(:star).round(2)
  end
end
