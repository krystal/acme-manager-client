require "net/http"
require "uri"
require "json"

module AcmeManager
  # Simplify the process of making an API request to acme-manager
  class Request
    PATH_PREFIX = "~acmemanager/".freeze

    attr_reader :path, :error_type, :error

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
      AcmeManager.logger.debug "Requesting #{request_uri}"

      http = new_http_connection

      request = Net::HTTP::Get.new(request_uri.path)
      request["X-API-KEY"] = AcmeManager.config.api_key

      result = http.request(request)

      AcmeManager.logger.debug "Response Status: #{result.code}"
      AcmeManager.logger.debug "Response Body:\n#{result.body}"

      if result.is_a?(Net::HTTPSuccess)
        JSON.parse(result.body)
      else
        AcmeManager.logger.warn "Request to #{request_uri} failed"
        result.value
      end
    end

    private

    # Build a new connection object to the configured acme-manager host.
    #
    # @return [Net::HTTP] Connection object
    def new_http_connection
      http = Net::HTTP.new(request_uri.host, request_uri.port)
      if request_uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end

      http
    end

    # Build a complete URL for the request and parse it with URI
    #
    # @return [URI::HTTP] Parsed request URI
    def request_uri
      @request_uri ||= URI("#{AcmeManager.config.host}/#{PATH_PREFIX}#{path}")
    end
  end
end
