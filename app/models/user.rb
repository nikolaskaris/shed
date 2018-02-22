class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable

  validates :fullname, presence: :true, length: { maximum: 50 }


  has_many :gears
  has_many :reservations

  has_many :borrower_reviews, class_name: "BorrowerReview", foreign_key: "borrower_id"
  has_many :owner_reviews, class_name: "OwnerReview", foreign_key: "owner_id"

  
  # SMS Verification - Twilio #
  def generate_pin
    self.pin = SecureRandom.hex(2)
    self.phone_verified = false
    save
  end

  def send_pin
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: '+1 (518) 551-2169',
      to: self.phone_number,
      body: "Your pin is #{self.pin}"
      )
  end

  def verify_pin(entered_pin)
    update(phone_verified: true) if self.pin == entered_pin
  end
  # SMS Verification - Twilio #
  
end
