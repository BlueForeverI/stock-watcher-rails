require 'net/http'
require 'json'

class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find params[:id]
    render json: @user
  end

  def stocks
    user = User.find params[:id]
    render json: user.stocks
  end

  def add_stock
    user = User.find params[:user_id]
    stock = Stock.find params[:id]
    user.stocks << stock
    user.save
    render json: {}
  end

  def remove_stock
    user = User.find params[:user_id]
    stock = Stock.find params[:stock_id]
    user.stocks.delete stock
    user.save
    render json: {}
  end

  def watchlist
    user = User.find params[:id]
    stocks = JSON.parse(user.stocks.to_json)
    render json: (stocks.map do |x|
      get_stock_price(x['symbol'], x['id'])
    end)
  end

  def get_stock_price(symbol, id)
    url = URI.parse("https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-profile?symbol=#{symbol}")
    req = Net::HTTP::Get.new(url.to_s)
    req['x-rapidapi-key'] = ENV['YAHOO_API_KEY']
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http|
      http.request(req)
    }
    parsed = JSON.parse res.body
    {
      :StockId => id,
      :price => {
        :regularMarketPrice => parsed['price']['regularMarketPrice'],
        :regularMarketChangePercent => parsed['price']['regularMarketChangePercent']
      },
      :quoteType => {
        :longName => parsed['quoteType']['longName'],
        :symbol => parsed['quoteType']['symbol']
      }
    }
  end
end