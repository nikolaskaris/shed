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
    gear = Gear.find(params[:gear_id])

    if current_user == gear.user
      flash[:alert] = "You cannot book your own gear."
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      @reservation = current_user.reservation.build(reservation_params)
      @reservation.gear = gear
      @reservation.price = gear.price
      @reservation.total = gear.price * days
      @reservation.save

      flash[:notice] = "Booked Successfully!"
    end
    redirect_to gear
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
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
