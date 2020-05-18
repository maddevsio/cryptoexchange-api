#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'cryptoexchange'
require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  client = Cryptoexchange::Client.new
  result = {}
  result['pairs'] = []
  pairs = client.pairs(params[:dce])
  pairs.each { |p| result['pairs'] << { 'symbol' => "#{p.base}-#{p.target}" } }
  result.to_json
end

get '/ticker' do
  client = Cryptoexchange::Client.new
  result = {}
  result['ticker'] = []
  pair = Cryptoexchange::Models::MarketPair.new(base: params[:base], target: params[:target], market: params[:market])
  ticker = client.ticker(pair)
  result['ticker'] << {
    'last' => ticker.last,
    'bid' => ticker.bid,
    'ask' => ticker.ask,
    'high' => ticker.high,
    'low' => ticker.low,
    'change' => ticker.change,
    'volume' => ticker.volume
  }
  result.to_json
end
