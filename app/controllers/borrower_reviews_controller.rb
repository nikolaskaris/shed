class BorrowerReviewsController < ApplicationController

  def create
    # Step 1: Check if the reservation exists (gear_id, owner_id, owner_id)

    # Step 2: Check if the current owner already reviewed the borrower in this reservation

    @reservation = Reservation.where(id: borrower_review_params[:reservation_id],
                                     gear_id: borrower_review_params[:gear_id]
                                     ).first

    if !@reservation.nil? && @reservation.gear.user.id == borrower_review_params[:owner_id].to_i

      @has_reviewed = BorrowerReview.where(
                          reservation_id: @reservation.id,
                          owner_id: borrower_review_params[:owner_id]
                          ).first
      
      if @has_reviewed.nil?
        #Allow to review
        @borrower_review = current_user.borrower_reviews.create(borrower_review_params)
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
    @borrower_review = Review.find(params[:id])
    @borrower_review.destroy

    redirect_back(fallback_location: request.referrer, notice: "Removed")
  end

  private
    def borrower_review_params
      params.require(:borrower_review).permit(:comment, :star, :gear_id, :reservation_id, :owner_id)
    end

end