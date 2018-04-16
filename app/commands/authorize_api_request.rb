class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_accessor :headers

  def user
    @user ||= User.find(decode_with_auth_token[:user_id]) if decode_with_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decode_with_auth_token
    @decode_with_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if has_authorization?
      return authorization
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end

  def has_authorization?
    headers['Authorization'].present?
  end

  def authorization
    headers['Authorization'].split(' ').last
  end
end