module AcmeManager
  # Handles the request and response associated with issuing a new certificate through acme-manager
  class IssueRequest
    SUCCESSFUL_RESULTS = %w(issued not_due).freeze

    attr_reader :name, :success, :error_type, :error

    # @param [String] name Domain name to issue a cert for
    def initialize(name)
      @name = name
    end

    # Convenience method for issuing a new certificate
    #
    # @param [String] name Domain name to issue a cert for
    #
    # @return [IssueRequest] A new instance after the request has been made
    def self.make(name)
      request = new(name)
      request.make
      request
    end

    # Send a request to acme-manager to issue a new certificate. If the request is a failure error_type and error will
    # be set containing the failure details.
    #
    # @return [Boolean] true if the request was successful.
    def make
      AcmeManager.logger.info "Requesting certificate issue for '#{name}'"
      response = Request.make("issue/#{name}")

      if SUCCESSFUL_RESULTS.include?(response['result'])
        AcmeManager.logger.info "Issue for '#{name}' successful"
        @success = true
      else
        @error_type = response['reason']['type']
        @error = response['reason']['detail']
        AcmeManager.logger.warn "Issue for '#{name}' failed - #{error_type}, #{error}"
        @success = false
      end
    end

    # Was the request sucessful? This will return false if the request hasn't been made yet
    def success?
      !!@success
    end
  end
end
