module ControllerSpecHelper
  # generate tokens from household token
  def token_generator(household_token)
    JsonWebToken.encode(household_token: household_token)
  end

  # generate expired tokens from household token
  def expired_token_generator(household_token)
    JsonWebToken.encode({ household_token: household_token }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(thermostat.household_token),
      "Content-Type" => "application/json"
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end