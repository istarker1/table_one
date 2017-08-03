class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?


  def user_logged_in?
    if current_user
      true
    else
      false
    end
  end

  helper_method :correct_user
  def check_for_user_event_host
    if !@event.users.include?(current_user)
      flash[:notice] = "You are not authorized to view this page" if !current_user.nil?
      redirect_to root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

end
