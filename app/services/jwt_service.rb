# frozen_string_literal: true

# JwtService is a service class that is responsible for encoding and decoding JWT tokens. The encode method is called from the AuthenticationController class when a user logs in. The decode method is called from the AuthorizeApiRequest class when a user makes a request to the API. This class is used to encode and decode JWT tokens.
class JwtService
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).first
  end
end
