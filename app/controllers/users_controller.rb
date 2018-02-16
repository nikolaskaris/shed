class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @gears = @user.gears

    # Display all the borrower reviews to owner (if this user is a host)
    @borrower_reviews = Review.where(type: "BorrowerReview", owner_id: @user.id)

    # Display all the owner reviews to owner (if this user is a owner)
    @owner_reviews = Review.where(type: "OwnerReview", borrower_id: @user.id)
  end
end