module AcmeManager
  # All global configuration for AcmeManager client
  class Configuration
    attr_writer :host, :api_key

    # @return [String] The hostname where acme-manager is running. Set via accessor or by reading environment variable
    #   ACME_MANAGER_HOST
    #
    # @raise [AcmeManager::Error] Raised when unconfigured
    def host
      @host || ENV['ACME_MANAGER_HOST'] || raise(Error, "`host` has not been configured. Set it using the " \
        "`AcmeManager.configure` block or use the `ACME_MANAGER_HOST` environment variable")
    end

    # @return [String] The API key used to authenticate with acme-manager is running. Set via accessor or by reading
    #   environment variable ACME_MANAGER_API_KEY
    #
    # @raise [AcmeManager::Error] Raised when unconfigured
    def api_key
      @api_key || ENV['ACME_MANAGER_API_KEY'] || raise(Error, "`api_key` has not been configured. Set it using the " \
        "`AcmeManager.configure` block or use the `ACME_MANAGER_API_KEY` environment variable")
    end
  end
end
