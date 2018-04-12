class InfosController < ApplicationController
  skip_before_action :check_user_account_complete!

  def show
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to info_url, notice: "Your profile is updated."
    else
      redirect_to info_url, alert: "Problem updating your profile."
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
