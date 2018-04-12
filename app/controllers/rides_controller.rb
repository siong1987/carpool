class RidesController < ApplicationController
  before_action :check_existing_carpool, only: [:new, :create]

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
    @ride = current_user.ride
    @from_city_fullname = City.where(id: @ride.from_city_id).first.try(:fullname)
    @to_city_fullname = City.where(id: @ride.to_city_id).first.try(:fullname)
  end

  def update
    @ride = current_user.ride

    if @ride.update_attributes(ride_params)
      redirect_to edit_ride_url(@ride), notice: "Your carpool has been updated."
    else
      flash[:alert] = "Error when updating your carpool."

      @from_city_fullname = City.where(id: @ride.from_city_id).first.try(:fullname)
      @to_city_fullname = City.where(id: @ride.to_city_id).first.try(:fullname)

      render :edit
    end
  end

  private

  def check_existing_carpool
    if current_user.has_ride?
      redirect_to edit_ride_url(current_user.ride), alert: "You can only have one carpool at a time."
      return
    end
  end

  def ride_params
    params.require(:ride).permit(:from_city_id, :to_city_id, :note)
  end
end
