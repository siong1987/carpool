class RidesController < ApplicationController
  def new
    @ride = Ride.new
  end

  def create
    @ride = Ride.new(ride_params)
    @ride.user = current_user

    if @ride.save
      redirect_to root_url, notice: "Congratulations, your carpool has been created."
    else
      flash[:alert] = "Error when creating your carpool."

      @from_city_fullname = City.where(id: @ride.from_city_id).first.try(:fullname)
      @to_city_fullname = City.where(id: @ride.to_city_id).first.try(:fullname)

      render :new
    end
  end

  private

  def ride_params
    params.require(:ride).permit(:from_city_id, :to_city_id, :note)
  end
end
