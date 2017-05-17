class EquipmentsController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]

  def index
    @equipment = current_user.equipment
  end

  def show
  end

  def new
    @equipment = current_user.equipment.build
  end

  def create
    @equipment = current_user.equipment.build(equipment_params)

    if @equipment.save
      redirect_to @equipment, notice: "Saved!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @equipment.update(equipment_params)
      redirect_to @equipment, notice: "Updated!"
    else
      render :edit
    end
  end

  private
    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    def equipment_params
      params.require(:equipment).permit(:gear_type, :activity, :size, :listing_name, :summary, :location, :price)
    end
end
