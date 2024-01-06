# app/controllers/api/users_controller.rb
class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create, :new]

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to customers_path, notice: 'Logged in successfully!'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  private

  def user_params
    puts params.inspect
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
