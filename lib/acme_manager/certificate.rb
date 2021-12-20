module AcmeManager
  # Represents a certificaate managed by acme-manager
  class Certificate
    attr_accessor :name, :not_after

    # @param [String] name Domain name the certificate relates to
    # @param [Time] not_after Timestamp representing the expiry time of the certificate
    def initialize(name, not_after)
      self.name = name
      self.not_after = not_after
    end

    # Certificate is expired when we're past it's expiry time
    def expired?
      Time.now.utc > not_after
    end

    # Fetch a list of all certificates that acme-manager is currently managing
    #
    # @return [Array<Certificate>] All currently managed certificates
    def self.all
      Request.make("list").map do |cert_info|
        AcmeManager.logger.info "Requesting list of certificates"
        new(cert_info["name"], Time.iso8601(cert_info["not_after"]))
      end
    end
  end
end
