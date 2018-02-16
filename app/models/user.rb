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
  
end
