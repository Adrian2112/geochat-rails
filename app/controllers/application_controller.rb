class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate!

  def authenticate!
    if !signed_in?
      flash[:error] = "You need to sign in first"
      redirect_to root_path
    end
  end

  def signed_in?
    current_user
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
