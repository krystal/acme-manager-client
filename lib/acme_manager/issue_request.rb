module AcmeManager
  # Handles the request and response associated with issuing a new certificate through acme-manager
  class IssueRequest < Request
    PATH_PREFIX = "issue/".freeze
    SUCCESSFUL_RESULTS = %w[issued not_due].freeze

    attr_reader :name, :success
    alias name path

    # Send a request to acme-manager to issue a new certificate. If the request is a failure error_type and error will
    # be set containing the failure details.
    #
    # @return [IssueRequest] An instance after the request has been made.
    def make
      AcmeManager.logger.info "Requesting certificate issue for '#{name}'"
      response = self.class.superclass.make(PATH_PREFIX + name)

      if SUCCESSFUL_RESULTS.include?(response["result"])
        AcmeManager.logger.info "Issue for '#{name}' successful"
        @success = true
      else
        @error_type = response["reason"]["type"]
        @error = response["reason"]["detail"]
        AcmeManager.logger.warn "Issue for '#{name}' failed - #{error_type}, #{error}"
        @success = false
      end

      self
    end

    # Was the request sucessful? This will return false if the request hasn't been made yet
    def success?
      !!@success
    end
  end
end
