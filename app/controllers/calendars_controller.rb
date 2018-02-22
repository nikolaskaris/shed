class CalendarsController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def create
    date_from = Date.parse(calendar_params[:start_date])
    date_to = Date.parse(calendar_params[:end_date])

    (date_from..date_to).each do |date|
      calendar = Calendar.where(gear_id: params[:gear_id], day: date)

      if calendar.present?
        calendar.update_all(price: calendar_params[:price], status: calendar_params[:status])
      else
        Calendar.create(
          gear_id: params[:gear_id],
          day: date,
          price: calendar_params[:price],
          status: calendar_params[:status]
          )
      end
    end

    redirect_to owner_calendar_path
  end

  def owner
    @gears = current_user.gears
    params[:start_date] ||= Date.current.to_s
    params[:gear_id] ||= @gears[0] ? @gears[0].id : nil

    if params[:q].present?
      params[:start_date] = params[:q][:start_date]
      params[:gear_id] = params[:q][:gear_id]
    end

    @search = Reservation.ransack(params[:q])


    if params[:gear_id]
      @gear = Gear.find(params[:gear_id])
      start_date = Date.parse(params[:start_date])

      first_of_month = (start_date - 1.months).beginning_of_month # => Jun 1
      end_of_month = (start_date + 1.months).end_of_month # => Aug 31
      @events = @gear.reservations.joins(:user)
                      .select('reservations.*, users.fullname, users.image, users.email, users.uid')
                      .where('(start_date BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)
      @events.each{ |e| e.image = avatar_url(e) }
      @days = Calendar.where("gear_id = ? AND day BETWEEN ? AND ?", params[:gear_id], first_of_month, end_of_month)
    else
      @gear = nil
      @events = []
      @days = []
    end
  end

  private
    def calendar_params
      params.require(:calendar).permit([:price, :status, :start_date, :end_date])
    end
end    