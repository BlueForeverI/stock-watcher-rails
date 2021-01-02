require 'net/http'
require 'json'

class StocksController < ApplicationController
  def index
    @stocks = Stock.all
    render json: @stocks
  end

  def show
    @stock = Stock.find(params[:id])
    render json: @stock
  end

  def trending
    url = URI.parse('https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-trending-tickers')
    req = Net::HTTP::Get.new(url.to_s)
    req['x-rapidapi-key'] = ENV['YAHOO_API_KEY']
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) {|http|
      http.request(req)
    }
    parsed = JSON.parse res.body
    full_list = parsed['finance']['result'][0]['quotes']
    render json: full_list.map { |stock|
      {
        'symbol' => stock['symbol'],
        'longName' => stock['longName'],
        'regularMarketChangePercent' => stock['regularMarketChangePercent']
      }
    }
  end
end