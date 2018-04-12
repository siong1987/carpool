class SessionController < ApplicationController
  skip_before_action :authenticate_user!, :check_user_account_complete!
  before_action :verify_state_csrf_token, only: [:index]

  def index
    user = User.validate(params[:code])
    log_in user

    if user.account_complete?
      redirect_to root_url, notice: "Logged in successfully!"
    else
      redirect_to info_url, notice: "Logged in successfully! Complete your account by letting us know your name."
    end
  end

  def destroy
    log_out
    redirect_to root_url, notice: "Logged out successfully!"
  end

  private

  def verify_state_csrf_token
    render file: "public/422.html", status: :unprocessable_entity unless valid_authenticity_token?(session, params[:state])
  end
end
