class UsersController < ApplicationController
  before_action :find_and_set_user, only: [:show, :edit, :update]
  before_action :require_signed_in!, except: [:new, :create]
  
  def index
    @users = User.all
    render :index
  end
  
  def show
    render :show
  end
  
  def edit
    render :edit
  end
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.create(user_params)
    
    if @user.save
      sign_in!(@user)
      redirect_to @user
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "User successfully updated!"
      redirect_to @user
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
    def find_and_set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation)
    end
end
