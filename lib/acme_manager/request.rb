require 'net/http'
require 'uri'
require 'json'

module AcmeManager
  # Simplify the process of making an API request to acme-manager
  class Request
    PATH_PREFIX = '/~acmemanager/'.freeze

    # @param [String] path The API call you wish to make. This will have PATH_PREFIX prepended to it when
    #   making a request
    def initialize(path)
      @path = path
    end

    # Convenicence method to make a new instance and return the result of the request
    #
    # @param [String] path The API call you wish to make. See #new for more details.
    def self.make(path)
      new(path).make
    end

    # Make a request to the acme-manager API. Requests will be sent to the host defined in AcmeManager.config, and
    # sent with the API key from the same configuration.
    #
    # Successfull responses are assumed to be in JSON format and are automatically parsed
    #
    # @return [Array, Hash] Parsed JSON data returned from the API
    #
    # @raise [Net::HTTPError] Raised when a non-2xx result is returned
    def make
      http = new_http_connection

      request = Net::HTTP::Get.new(PATH_PREFIX + @path.to_s)
      request['X-API-KEY'] = AcmeManager.config.api_key

      result = http.request(request)

      if result.is_a?(Net::HTTPSuccess)
        JSON.parse(result.body)
      else
        result.value
      end
    end

    private

    # Build a new connection object to the configured acme-manager host.
    #
    # @return [Net::HTTP] Connection object
    def new_http_connection
      host_uri = URI(AcmeManager.config.host)

      http = Net::HTTP.start(host_uri.host, host_uri.port)
      if host_uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end

      http
    end
  end
end
