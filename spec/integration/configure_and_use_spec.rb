require 'bunny_exchanges'

RSpec.describe "configure and use" do

  it 'works properly' do
    BunnyExchanges.configure do |config|
      config.exchanges_path = File.expand_path("../test_exchanges_config.yml", __FILE__)
      config.connections    = {default: File.expand_path("../test_rabbitmq_config.yml", __FILE__)}
      config.env = "test"
    end

    exchange = BunnyExchanges.get(:the_action)

    expect(exchange).to be_a Bunny::Exchange

    expect(exchange.name).to eq "a.real.exchange"
    expect(exchange.type).to eq "fanout"
  end

end
