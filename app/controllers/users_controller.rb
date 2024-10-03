class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def show
    @user = User.find(params[:id])
    @valid_user = @user.dup
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if user_params[:password] != user_params[:password_confirmation]
      @user.errors.add(:password, "doesn't match confirmation")
      return render :new, status: :unprocessable_entity
    end

    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user
    else
      @valid_user = User.find(params[:id])
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :first_name, :last_name, :email_address, :password, :password_confirmation)
  end
end
