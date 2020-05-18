#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'cryptoexchange'
require 'sinatra'
require 'logger'

set :bind, '0.0.0.0'

logger = Logger.new(STDOUT)

get '/' do
  begin
    result = { 'pairs' => [] }
    pairs = Cryptoexchange::Client.new.pairs(params[:dce])
  rescue StandardError => e
    logger.error("#{e.message} #{e.class}\n")
  else
    pairs.each { |p| result['pairs'] << { 'symbol' => "#{p.base}-#{p.target}" } }
    result.to_json
  end
end

get '/ticker' do
  begin
    pair = Cryptoexchange::Models::MarketPair.new(base: params[:base], target: params[:target], market: params[:market])
    ticker = Cryptoexchange::Client.new.ticker(pair)
  rescue StandardError => e
    logger.error("#{e.message} #{e.class}\n")
  else
    { 'ticker' => [] << {
      'last' => ticker.last,
      'bid' => ticker.bid,
      'ask' => ticker.ask,
      'high' => ticker.high,
      'low' => ticker.low,
      'change' => ticker.change,
      'volume' => ticker.volume
    } }.to_json
  end
end
