class ReviewsController < ApplicationController

  def create
    @review = current_user.reviews.create(review_params)
    redirect_to @review.gear 
  end

  def destroy
    @review = Review.find(params[:id])
    gear = @review.gear
    @review.destroy

    redirect_to gear
  end

  private
  def review_params
    params.require(:review).permit(:comment, :star, :gear_id)
  end
end
