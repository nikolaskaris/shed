class BorrowerReview < Review
  belongs_to :borrower, class_name: "User"
end
