require 'bunny_exchanges/configuration'

RSpec.describe BunnyExchanges::Configuration do

  subject { described_class.new }

  describe '#path= and #exchanges' do
    let :config_file do
      File.expand_path("../configuration/test_examples_configuration.yml" ,__FILE__)
    end

    let :expected_exchanges do
      {
        "service_1" => {
          "action_1" => {
            "name" => "an.exchange.name",
            "type" => "fanout",
            "durable" => true,
            "auto_delete" => false,
            "arguments" => {
              "one" => 1,
              "two" => "second"
            }
          },
          "action_2" => {
            "name" => "the.name"
          },
        },
        "service_2" => {
          "action_1" => {
            "name" => "another",
            "type" => "topic"
          }
        }
      }
    end

    it 'parses the exchanges config from a yaml file' do
      subject.path = config_file

      expect(subject.exchanges).to eq expected_exchanges
    end
  end

end
