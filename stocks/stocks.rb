#!/usr/bin/env ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'iex-ruby-client'
require 'colorize'

def stock
  symbol = ARGV.join(' ')
  token = ENV['IEX_API_TOKEN'] || 'x'

  begin
    uri = URI("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=#{symbol}&lang=en%22")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    parsed_symbol = data['ResultSet']['Result'][0]['symbol'].split('.')[0]
  rescue
    puts %(The stock "#{symbol}" not found)
    exit(1)
  end

  client = IEX::Api::Client.new(
    publishable_token: token.to_s
  )

  quote = client.quote(parsed_symbol)
  quote_change = quote['change']
  quote_change_percent = quote['change_percent']

  case quote['primary_exchange']
  when 'NASDAQ'
    exchange = 'NASDAQ'
  when 'New York Stock Exchange'
    exchange = 'NYSE'
  end

  puts '=========================='
  puts "Symbol: #{quote['symbol']}"
  puts "Price: #{quote['latest_price']}"
  puts "PE Ratio: #{quote['pe_ratio']}"
  puts "Mkt Cap: #{quote['market_cap']}%"
  puts "Exchange: #{exchange}"

  if quote['change'].positive?
    puts "Chg: +#{quote_change}".green
  else
    puts "Chg: #{quote_change}".red
  end
  if quote_change_percent.positive?
    puts "Chg: +#{quote_change_percent}%".green
  else
    puts "Chg: #{quote_change_percent}%".red
  end

end

stock
