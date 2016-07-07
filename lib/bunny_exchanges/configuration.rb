require 'yaml'

module BunnyExchanges
  # It stores the exchanges configuration.
  class Configuration
    DEFAULT_EXCHANGES_PATH = "config/exchanges.yml"
    DEFAULT_RABBITMQ_PATH  = "config/rabbitmq.yml"

    # Sets the path of the exchanges configuration file.
    #
    # @param [String] a path.
    attr_writer :exchanges_path

    # Sets the hash path of the rabbitmq configuration file.
    #
    # @param [Hash] {:connection_name => "path_to_config.yml"}.
    attr_writer :connections

    # Sets the ENV. If it is set, the rabbitmq configuration
    # for that env is taken, otherwise it gets the rabbitmq config file
    # contents directly.
    #
    # @param [String] the env.
    attr_writer :env

    # Constructor.
    def initialize
      @exchanges_path = DEFAULT_EXCHANGES_PATH
      @connections    = {default: DEFAULT_RABBITMQ_PATH}
      @configs = {}
    end

    # Loads the configuration YAML file contents.
    #
    # @return [Hash] the exchanges configuration.
    def exchanges
      @exchanges ||= YAML.load_file(exchanges_path)
    end

    # Loads the configuration YAML file contents for the environment if given.
    #
    # @return [Hash] the rabbitmq configuration.
    def connection_config connection_name
      @configs[connection_name] ||= if env
        rabbitmq_contents(connection_name).fetch(env)
      else
        rabbitmq_contents connection_name
      end
    end

  private

    def rabbitmq_contents connection_name
      YAML.load_file(connections[connection_name])
    end

    attr_reader :env, :exchanges_path, :connections
  end
end
