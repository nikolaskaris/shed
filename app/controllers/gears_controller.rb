class GearsController < ApplicationController
  before_action :set_gear, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: [:listing, :pricing, :description, :photo_upload, :location, :update]

  def index
    @gears = current_user.gears
  end

  def show
    @photos = @gear.photos
    @borrower_reviews = @gear.borrower_reviews    
  end

  def new
    @gear = current_user.gears.build
  end

  def create
    @gear = current_user.gears.build(gear_params)

    if @gear.save

      if params[:images]
        params[:images].each do |image|
          @gear.photos.create(image: image)
        end
      end

      @photos = @gear.photos
      redirect_to listing_gear_path(@gear), notice: "Saved!"
    else
      flash[:alert] = "Please provide all information for your gear listing"
      render :new
    end
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @gear.photos
  end

  def location
  end

  def update

    new_params = gear_params
    new_params = gear_params.merge(active: true) if is_ready_gear

    if @gear.update(new_params)

      if params[:images]
        params[:images].each do |image|
          @gear.photos.create(image: image)
        end
      end

      redirect_to listing_gear_path(@gear), notice: "Updated!"
    else
      render :edit
      flash[:alert] = "Please provide all information for this listing."
    end
  end

  # Reservations
  def preload
    today = Date.today
    reservations = @gear.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
    
    render json: reservations
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @gear)
    }

    render json: output
    
  end

  private
    def is_conflict(start_date, end_date, gear)
      check = gear.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
      check.size > 0? true : false
    end

    def set_gear
      @gear = Gear.find(params[:id])
    end

    def is_authorized
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @gear.user_id
    end

    def is_ready_gear
      !@gear.price.blank? && !@gear.listing_name.blank? && !@gear.photos.blank? && !@gear.location.blank?
    end

    def gear_params
      params.require(:gear).permit(:activity, :gear_type, :size, :listing_name, :summary, :location, :price, :active, :instant)
    end
end
