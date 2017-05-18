require "acme_manager/version"
require "acme_manager/configuration"
require "acme_manager/request"
require "acme_manager/certificate"
require "acme_manager/issue_request"

module AcmeManager
  class Error < StandardError; end;

  # @return [Configuration] The current configuration (or new if uninitialized)
  def self.config
    @config ||= Configuration.new
  end

  # Pass a block to configure the AcmeManager client
  #
  # @yieldparam [Configuration] Current configuration (see #config)
  #
  # @return [Configuration] Configuration after block has been called
  def self.configure
    yield config
    config
  end

  # Get a list of certificates currently managed by the acme-manager
  #
  # @return [Array<Certificate>] List of certificates
  def self.list
    Certificate.all
  end

  # Instruct the acme-manager to issue a new certificate
  #
  # @param [String] name Domain name to issue a new certificate for
  #
  # @return [IssueRequest] Object containing result of the issue request
  def self.issue(name)
    IssueRequest.make(name)
  end

  def self.logger
    @logger ||= begin
      logger = Logger.new(config.log_path)
      logger.level = config.log_level
      logger
    end
  end

  # Allow a custom logger to be set instead of configuring our own
  #
  # @param [Logger] new_logger Custom logger to set
  def self.logger=(new_logger)
    @logger = new_logger
  end
end
