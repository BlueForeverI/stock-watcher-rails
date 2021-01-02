class AuthController < ApplicationController
  def login
    email = params[:email]
    user = User.find_by(email: email)
    if user == nil
      user = User.new(email: email)
      user.save
    end
    render json: user
  end
end
