class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.missing_token
    'Missing token'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.expired_token
    'Sorry, your token has expired.'
  end
end