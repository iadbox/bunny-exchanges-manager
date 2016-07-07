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
  # @param [Symbol, Hash] the action name and the connection_name
  # @return [Bunny::Exchange] the required exchange.
  # @raise [BunnyExchanges::UndefinedExchange] when the required example is not defined.
  # @see Tenant.using
  def self.get action, connection_name: :default
    manager.get(action, connection_name)
  end

  # Removes the current manager and starts a new one with the same configuration.
  # Useful after forking or in any situation where a reconnection is needed.
  def self.reset!
    @manager = nil
  end

  # The current instance of {BunnyExchanges::Manager}.
  #
  # @return [BunnyExchanges::Manager] the manager with the current configuration.
  # @see Tenant.using
  def self.manager
    @manager ||= Manager.new(configuration)
  end
end
