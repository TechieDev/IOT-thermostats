class ApplicationController < ActionController::API
	include Response
	include ExceptionHandler

	before_action :authorize_request
	attr_reader :current_thermostat

	private

  def authorize_request
		@current_thermostat = (AuthorizeApiRequest.new(request.headers).call)[:thermostat]
	end
end
