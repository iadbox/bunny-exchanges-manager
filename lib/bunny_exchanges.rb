require "bunny_exchanges/version"

require "bunny_exchanges/configuration"
require "bunny_exchanges/manager"

module BunnyExchanges
  # BunnyExchanges configuration
  #
  # @return [Configuration] the current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # A helper to configure BunnyExchanges
  #
  # @yield [configuration] Configures tenantify
  def self.configure
    yield configuration
  end

  # Delegates `#get` to the current manager.
  # Returns the required exchange.
  #
  # @param [Symbol, String] the action name
  # @return [Bunny::Exchange] the required exchange.
  # @raise [BunnyExchanges::UndefinedExchange] when the required example is not defined.
  # @see Tenant.using
  def self.get action
    manager.get(action)
  end

  # The current instance of {BunnyExchanges::Manager}.
  #
  # @return [BunnyExchanges::Manager] the manager with the current configuration.
  # @see Tenant.using
  def self.manager
    @manager ||= Manager.new(configuration)
  end
end
