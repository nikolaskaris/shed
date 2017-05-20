class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def preload
    gear = Gear.find(params[:gear_id])
    today = Date.today
    reservations = gear.reservations.where("start_date >= ? OR end_date >= ?", today, today)

    render json: reservations
  end

  def create
    @reservation = current_user.reservations.create(reservation_params)

    redirect_to @reservation.gear, notice: "Your reservation has been created!"
  end

  private
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date, :price, :total, :gear_id)
    end
end
