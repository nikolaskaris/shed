class PhotosController < ApplicationController

  def create
    @gear = Gear.find(params[:gear_id])

    if params[:images]
      params[:images].each do |img|
        @gear.photos.create(image: img)
      end

      @photos = @gear.photos
      redirect_back(fallback_location: request.referer, notice: "Saved...")
    end
  end


  def destroy
    @photo = Photo.find(params[:id])
    @gear = @photo.gear

    @photo.destroy
    @photos = Photo.where(gear_id: @gear.id)

    respond_to :js
  end
end

