class RidesController < ApplicationController
  before_action :check_existing_carpool, only: [:new, :create]
  before_action :set_ride, only: [:edit, :update, :destroy]

  def new
    @ride = Ride.new
  end

  def create
    @ride = Ride.new(ride_params)
    @ride.user = current_user

    if @ride.save
      redirect_to edit_ride_url(@ride), notice: "Congratulations, your carpool has been created."
    else
      flash[:alert] = "Error when creating your carpool."

      @from_city_fullname = City.where(id: @ride.from_city_id).first.try(:fullname)
      @to_city_fullname = City.where(id: @ride.to_city_id).first.try(:fullname)

      render :new
    end
  end

  def edit
    @from_city_fullname = City.where(id: @ride.from_city_id).first.try(:fullname)
    @to_city_fullname = City.where(id: @ride.to_city_id).first.try(:fullname)
  end

  def update
    if @ride.update_attributes(ride_params)
      redirect_to edit_ride_url(@ride), notice: "Your carpool has been updated."
    else
      flash[:alert] = "Error when updating your carpool."

      @from_city_fullname = City.where(id: @ride.from_city_id).first.try(:fullname)
      @to_city_fullname = City.where(id: @ride.to_city_id).first.try(:fullname)

      render :edit
    end
  end

  def destroy
    if @ride.destroy
      redirect_to new_ride_url, notice: "Your carpool has been deleted."
    else
      redirect_to edit_ride_url(@ride), alert: "Error when deleting your carpool."
    end
  end

  private

  def check_existing_carpool
    if current_user.has_ride?
      redirect_to edit_ride_url(current_user.ride), alert: "You can only have one carpool at a time."
      return
    end
  end

  def set_ride
    @ride = current_user.ride

    if @ride.nil?
      redirect_to new_ride_url
    end
  end

  def ride_params
    params.require(:ride).permit(:from_city_id, :to_city_id, :note)
  end
end
