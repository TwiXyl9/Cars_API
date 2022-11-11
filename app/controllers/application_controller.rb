require 'errors/lack_access_rights'
class ApplicationController < ActionController::API
        before_action :configure_permitted_parameters, if: :devise_controller?
        include DeviseTokenAuth::Concerns::SetUserByToken
        include ActionController::Helpers
        helper_method :moderator?
        rescue_from ActiveRecord::RecordNotFound, with: :id_not_found

        protected
        def configure_permitted_parameters
                devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :phone])
        end
        def moderator?
                return head :unauthorized unless current_user
                raise(Errors::LackAccessRights)  unless !current_user.user?
        end

        def id_not_found(e)
                render json: {errors: e}, status: :not_found
        end
    end
