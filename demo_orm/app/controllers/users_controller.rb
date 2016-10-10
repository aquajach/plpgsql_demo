class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.where('email = ? OR phone = ?', params[:login], params[:login]).first
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render 'show'
    else
      @errors = @user.errors
      render 'error'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone, :name)
  end
end
