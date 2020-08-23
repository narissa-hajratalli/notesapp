class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login] #getting :authorized from the application controller
  # only run authorize beforehand for auto_login, because you need to be logged in to do the crud function

  # REGISTER
  def create
    @user = User.create(user_params) #create a user with the params we sent in, and stores that as an instance variable
    if @user.valid? #checks if it matches the schema
      token = encode_token({user_id: @user.id}) #encodes a new token making jwt
      render json: {user: @user, token: token} #renders the new input user information and its token
    else
      render json: {error: "Invalid username or password"}
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username]) #finds the username put in by the user and compares it to all the users in our db

    if @user && @user.authenticate(params[:password]) #authenticate is message in itself. authenticate returns pw if correct, it returns false if not
      #if user is found && you authenticate the password that's put in
      token = encode_token({user_id: @user.id}) #endocde the token
      render json: {user: @user, token: token} #sendback a token
    else
      render json: {error: "Invalid username or password"}
    end
  end


  def auto_login
    render json: @user #checks to see if we have the token in the header
  end

  private

  def user_params # grabs the parameters from the request, grab username, pw, and age from what the user inputs
    params.permit(:username, :password, :age)
  end

end