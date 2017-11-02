class GearsController < ApplicationController
  before_action :set_gear, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: [:listing, :pricing, :description, :photo_upload, :location, :update]

  def index
    @gears = current_user.gears
  end

  def show
    @photos = @gear.photos

    @booked = Reservation.where("gear_id = ? AND user_id = ?", @gear.id, current_user.id).present? if current_user

    @reviews = @gear.reviews
    @hasReview = @reviews.find_by(user_id: current_user.id) if current_user
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

  def edit
    if current_user.id == @gear.user.id
      @photos = @gear.photos
    else
      redirect_to root_path, notice: "You don't have permission."
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
    if @gear.update(gear_params)

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

  private
  def set_gear
    @gear = Gear.find(params[:id])
  end

  def is_authorized
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @gear.user_id
    
  end

  def gear_params
    params.require(:gear).permit(:activity, :gear_type, :size, :listing_name, :summary, :location, :price)
  end
end
