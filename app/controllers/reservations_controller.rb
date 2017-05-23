class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def preload
    gear = Gear.find(params[:gear_id])
    today = Date.today
    reservations = gear.reservations.where("start_date >= ? OR end_date >= ?", today, today)

    render json: reservations
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date   = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date)
    }

    render json: output
  end

  def create
    @reservation = current_user.reservations.create(reservation_params)

    redirect_to @reservation.gear, notice: "Your reservation has been created!"
  end

  def your_rentals
    @rentals = current_user.reservations
  end

  def your_reservations
    @gears = current_user.gears
  end

  private

    def is_conflict(start_date, end_date)
      gear = Gear.find(params[:gear_id])

      check = gear.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
      check.size > 0? true : false
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date, :price, :total, :gear_id)
    end
end
