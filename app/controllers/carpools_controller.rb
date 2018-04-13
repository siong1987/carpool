class CarpoolsController < ApplicationController
  before_action :check_existing_carpool, only: [:new, :create]
  before_action :set_carpool, only: [:edit, :update, :destroy, :full]

  def new
    @carpool = Carpool.new
  end

  def create
    @carpool = Carpool.new(carpool_params)
    @carpool.user = current_user

    if @carpool.save
      redirect_to edit_carpool_url(@carpool), notice: "Congratulations, your carpool has been created."
    else
      flash[:alert] = "Error when creating your carpool."

      @from_city_fullname = City.where(id: @carpool.from_city_id).first.try(:fullname)
      @to_city_fullname = City.where(id: @carpool.to_city_id).first.try(:fullname)

      render :new
    end
  end

  def edit
    @from_city_fullname = City.where(id: @carpool.from_city_id).first.try(:fullname)
    @to_city_fullname = City.where(id: @carpool.to_city_id).first.try(:fullname)
  end

  def update
    if @carpool.update_attributes(carpool_params)
      redirect_to edit_carpool_url(@carpool), notice: "Your carpool has been updated."
    else
      flash[:alert] = "Error when updating your carpool."

      @from_city_fullname = City.where(id: @carpool.from_city_id).first.try(:fullname)
      @to_city_fullname = City.where(id: @carpool.to_city_id).first.try(:fullname)

      render :edit
    end
  end

  def destroy
    if @carpool.destroy
      redirect_to new_carpool_url, notice: "Your carpool has been deleted."
    else
      redirect_to edit_carpool_url(@carpool), alert: "Error when deleting your carpool."
    end
  end

  def full
    if @carpool.update_attribute(:full, true)
      redirect_to new_carpool_url, notice: "Thank you for marking your carpool as full."
    else
      redirect_to edit_carpool_url(@carpool), alert: "Error when marking your carpool as full."
    end
  end

  def search
    @from_city = City.where(id: params[:from_city_id]).first
    @to_city = City.where(id: params[:to_city_id]).first

    @carpools = Carpool.search(@from_city, @to_city)
  end

  private

  def check_existing_carpool
    if current_user.has_carpool?
      redirect_to edit_carpool_url(current_user.carpool), alert: "You can only have one carpool at a time."
      return
    end
  end

  def set_carpool
    @carpool = current_user.carpool

    if @carpool.nil?
      redirect_to new_carpool_url
    end
  end

  def carpool_params
    params.require(:carpool).permit(:from_city_id, :to_city_id, :note)
  end
end
