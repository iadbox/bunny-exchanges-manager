require "bunny_exchanges/version"

require "bunny_exchanges/configuration"

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
end
