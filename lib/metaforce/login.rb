module Metaforce
  class Login
    def initialize(username, password, security_token=nil)
      @username, @password, @security_token = username, password, security_token
    end

    # Public: Perform the login request.
    #
    # Returns a hash with the session id and server urls.
    def login
      response = client.call :login, :message => { :username => username, :password => password }
      response.body[:login_response][:result]
    end

  private

    # Internal: Savon client.
    def client
      args = {
        :wsdl => Metaforce.configuration.partner_wsdl,
        :endpoint => Metaforce.configuration.endpoint
      }
      @client ||= Savon.client args do |opt|
        opt.ssl_verify_mode :none
        opt.ssl_version :TLSv1
      end
    end

    # Internal: Usernamed passed in from options.
    def username
      @username
    end

    # Internal: Password + Security Token combined.
    def password
      [@password, @security_token].join('')
    end
  end
end
