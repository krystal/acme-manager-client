module AcmeManager
  # Handles requet and response associated with purging an issued certificate
  class PurgeRequest < Request
    PATH_PREFIX = "purge/".freeze
    SUCCESSFUL_RESULTS = %w[purged].freeze

    attr_reader :name, :success
    alias name path

    # Send a reuqest to purge an existing certificate
    #
    # @return [PurgeRequest] An instance after the request has been made.
    def make
      AcmeManager.logger.info "Purging certificate for '#{name}'"
      response = self.class.superclass.make(PATH_PREFIX + name)

      if SUCCESSFUL_RESULTS.include?(response["result"])
        AcmeManager.logger.info "Certificate purge for '#{name}' successful"
        @success = true
      else
        @error_type = response["reason"]["type"]
        @error = response["reason"]["detail"]
        AcmeManager.logger.warn "Purging certificate for '#{name}' failed - #{error_type}, #{error}"
        @success = false
      end

      self
    end
  end
end
