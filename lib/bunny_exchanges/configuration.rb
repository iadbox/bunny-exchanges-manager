require 'yaml'

module BunnyExchanges
  # It stores the exchanges configuration.
  class Configuration
    DEFAULT_EXCHANGES_PATH = "config/exchanges.yml"

    # Sets the path of the configuration file.
    #
    # @param [String] a path.
    attr_writer :path

    # Constructor.
    def initialize
      @path = DEFAULT_EXCHANGES_PATH
    end

    # Loads the configuration YAML file contents.
    #
    # @return [Hash] the exchanges configuration
    def exchanges
      @exchanges ||= YAML.load_file(path)
    end

  private

    attr_reader :path
  end
end
