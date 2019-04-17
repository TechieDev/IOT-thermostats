class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  # Service entry point - return valid thermostat object
  def call
    {
      thermostat: thermostat
    }
  end

  private

  attr_reader :headers

  def thermostat
    # check if thermostat is in the database
    # memoize thermostat object
    @thermostat ||= Thermostat.find_by(household_token: decoded_auth_token[:household_token]) if decoded_auth_token
    # handle thermostat not found
    if @thermostat.nil?
      raise( ExceptionHandler::InvalidToken, ("#{Message.invalid_token}") ) 
    else
      @thermostat
    end
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # check for token in `Authorization` header
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
      raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
end