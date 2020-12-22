class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[last_name first_name middle_name])
  end

  def user_not_authorized(exception)
    flash[:alert] = t("pundit.#{exception.policy.class.to_s.underscore}.#{exception.query}")
    redirect_to(request.referrer || root_path)
  end
end
