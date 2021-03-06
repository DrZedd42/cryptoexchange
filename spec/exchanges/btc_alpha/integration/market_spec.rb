require 'spec_helper'

RSpec.describe 'BtcAlpha integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:lhcoin_eth_pair) { Cryptoexchange::Models::MarketPair.new(base: 'LHCoin', target: 'ETH', market: 'btc_alpha') }

  it 'fetch pairs' do
    pairs = client.pairs('btc_alpha')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'btc_alpha'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'btc_alpha', base: lhcoin_eth_pair.base, target: lhcoin_eth_pair.target
    expect(trade_page_url).to eq "https://btc-alpha.com/exchange/LHCOIN_ETH"
  end

  it 'fetch ticker' do
    ticker = client.ticker(lhcoin_eth_pair)

    expect(ticker.base).to eq 'LHCOIN'
    expect(ticker.target).to eq 'ETH'
    expect(ticker.market).to eq 'btc_alpha'
    expect(ticker.last).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be_a Numeric
    expect(2000..Date.today.year).to include(Time.at(ticker.timestamp).year)
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(lhcoin_eth_pair)

    expect(order_book.base).to eq 'LHCOIN'
    expect(order_book.target).to eq 'ETH'
    expect(order_book.market).to eq 'btc_alpha'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be nil
    expect(order_book.bids.first.amount).to_not be nil
    expect(order_book.bids.first.timestamp).to be nil
    expect(order_book.asks.count).to_not be nil
    expect(order_book.bids.count).to_not be nil
    expect(order_book.timestamp).to be_a Numeric
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(lhcoin_eth_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.trade_id).to_not be_nil
    expect(trade.base).to eq 'LHCOIN'
    expect(trade.target).to eq 'ETH'
    expect(trade.price).to_not be nil
    expect(trade.amount).to_not be nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
    expect(trade.market).to eq 'btc_alpha'
  end

end
