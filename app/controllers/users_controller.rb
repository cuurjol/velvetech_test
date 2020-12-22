class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    authorize(@user)
  end

  def edit
    authorize(@user)
  end

  def update
    authorize(@user)

    if @user.update(user_params)
      redirect_to(@user, notice: t('controllers.users.updated'))
    else
      render(:edit)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:last_name, :first_name, :middle_name, :email)
  end
end
