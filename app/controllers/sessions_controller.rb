class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end
  
  def create
    email = params[:user][:email]
    password = params[:user][:password]
    @user = User.find_by_credentials(email, password)
    
    if @user
      sign_in!(@user)
      redirect_to :root
    else
      flash.now[:errors] = ["Unable to sign in with those credentials."]
      @user = User.new
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    sign_out!
    redirect_to :root
  end
end
