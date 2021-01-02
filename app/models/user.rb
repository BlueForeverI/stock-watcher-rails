class User < ApplicationRecord
  has_and_belongs_to_many :stocks, :join_table => :user_stocks
  
end
