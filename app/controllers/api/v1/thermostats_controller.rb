module Api
	module V1
		class ThermostatsController < ApplicationController
			skip_before_action :authorize_request, only: :generate_auth_token

			def generate_auth_token
				if !params['household_token'].blank?
					@thermostat = Thermostat.find_by(household_token: params[:household_token])

			  	if @thermostat.present?
			  		@auth_token = JsonWebToken.encode({household_token: @thermostat.household_token})
			  		response = { thermostat: @thermostat, auth_token: @auth_token }
			      json_response(response)
			    else
			      raise(ExceptionHandler::InvalidHouseholdToken, Message.invalid_household_token)
			    end
			  else
			  	raise(ExceptionHandler::MissingHouseholdToken, Message.missing_household_token)
			  end
			end

			def stats
			end
		end
	end
end