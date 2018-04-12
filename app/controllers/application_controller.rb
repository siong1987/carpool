class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :check_user_account_complete!

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  helper_method :current_user

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  helper_method :logged_in?

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  protected

  def authenticate_user!
    unless current_user
      redirect_to root_url, alert: "You don't have the right to view this page."
    end
  end

  def check_user_account_complete!
    return unless current_user
    unless current_user.account_complete?
      redirect_to info_url, notice: "Logged in successfully! Complete your account by letting us know your name."
    end
  end
end
