class PagesController < ApplicationController
  def home
    @gears = Gear.all
  end

  def search
    
    if params[:search].present? && params[:search].strip != ""
      session[:gear_search] = params[:search]
    end

    arrResult = Array.new

    if session[:gear_search] && session[:gear_search] != ""
      @gears_address = Gear.near(session[:gear_search], 5, order: 'distance')
    else
      @gears_address = Gear.where(active: true).all
    end

    @search = @gears_address.ransack(params[:q])
    @gears = @search.result

    @arrGear = @gears.to_a

    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? && !params[:end_date].empty?)

      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @gears.each do |gear|

        not_available = gear.reservations.where(
          "(? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (? <= start_date AND ? < end_date)",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date
          ).limit(1)

        if not_available.length > 0
          @arrGear.delete(gear)
        end


      end
    end

  end
end
