class OwnerReviewsController < ApplicationController

  def create
    # Step 1: Check if the reservation exists (gear_id, borrower_id, owner_id)

    # Step 2: Check if the current owner already reviewed the borrower in this reservation

    @reservation = Reservation.where(id: owner_review_params[:reservation_id],
                                     gear_id: owner_review_params[:gear_id],
                                     user_id: owner_review_params[:borrower_id]
                                     ).first

    if !@reservation.nil?

      @has_reviewed = OwnerReview.where(
                          reservation_id: @reservation.id,
                          borrower_id: owner_review_params[:borrower_id]
                          ).first
      
      if @has_reviewed.nil?
        #Allow to review
        @owner_review = current_user.owner_reviews.create(owner_review_params)
        flash[:success] = "Review created..."
      else
        #Already reviewed
        flash[:success] = "You already reviewed this reservation"
      end
    else
      flash[:alert] = "This reservation was not found"
    end
    
    redirect_back(fallback_location: request.referrer)
  end

  def destroy
    @owner_review = Review.find(params[:id])
    @owner_review.destroy

    redirect_back(fallback_location: request.referrer, notice: "Removed")
  end

  private
    def owner_review_params
      params.require(:owner_review).permit(:comment, :star, :gear_id, :reservation_id, :borrower_id)
    end

end