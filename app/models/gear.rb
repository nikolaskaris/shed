class Gear < ApplicationRecord
  enum instant: {Request: 0, Instant: 1}

  belongs_to :user
  has_many   :photos
  has_many   :reservations
  

  has_many   :borrower_reviews
  has_many   :calendars

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
    borrower_reviews.count == 0 ? 0 : borrower_reviews.average(:star).round(2).to_i
  end
end
