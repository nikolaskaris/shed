class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

  def create
    gear = Gear.find(params[:gear_id])

    if current_user == gear.user
      flash[:alert] = "You cannot book your own gear."
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.gear = gear
      @reservation.price = gear.price
      @reservation.total = gear.price * days
      # @reservation.save

      if @reservation.save 
        if gear.Request?
          flash[:notice] = "Request sent successfully!"
        else
          @reservation.Approved!
          flash[:notice] = "Reservation created successfully!"
        end
      else
        flash[:alert] = "Cannot make a reservation."
      end

    end
    redirect_to gear
  end

  def your_rentals
    @rentals = current_user.reservations.order(start_date: :asc)
  end

  def your_bookings
    @gears = current_user.gears
  end

  def approve
    @reservation.Approved!
    redirect_to your_bookings_path
  end

  def decline
    @reservation.Declined!
    redirect_to your_bookings_path
  end

  private
    
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
