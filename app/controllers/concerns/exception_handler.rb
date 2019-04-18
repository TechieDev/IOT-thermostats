module ExceptionHandler
  extend ActiveSupport::Concern

  # StandardErrors - Custom subclasses for errors `
  class ExpiredSignature < StandardError; end
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class MissingHouseholdToken < StandardError; end
  class InvalidToken < StandardError; end
  class InvalidHouseholdToken < StandardError; end

  included do
    # Custom Handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::ExpiredSignature, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::MissingHouseholdToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidHouseholdToken, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private

  # Status code 422
  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # Status code 401
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end
end