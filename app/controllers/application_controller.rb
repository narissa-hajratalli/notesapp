# The application controller is the prototype for all your controllers
# building new features that all your routes have
# we build in authorization here because we want every route to work with authorization, i.e. they can only do something at this
# endpoint if they are logged in

class ApplicationController < ActionController::API
  before_action :authorized # before you access any route, the authorize function runs


  def encode_token(payload) #encodes your username
    JWT.encode(payload,  ENV['SECRET'])
  end
  # encode_token this method takes in a payload (a hash of key/values you want to save in the token)
  # and signs a token using a secret key. (in production this should an ENV variable.) => sign = create token

  def auth_header # gets the authorization header from the request
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header # if auth header is there
      token = auth_header.split(' ')[1] #split off the header and just store the token
      # header: { 'Authorization': 'Bearer <token>' } #this is the format of an authorization header
      begin
        JWT.decode(token,  ENV['SECRET'], true, algorithm: 'HS256') #decodes the jwt token using the secret, which must match what is in endcode and returns to you the
      rescue JWT::DecodeError # returns you the decoded token
        nil
      end
    end
  end

  def logged_in_user # checks if the decoded json token has a user in it and adds the user to the instance variable in the controller so all the routes can use it
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in? # checks is the user is logged in
    !!logged_in_user
  end

  def authorized #the authorize function will say please login and be unauthorized unless logging is = true
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end


# Steps
# 1. before_action
# 2. authorize method to see if the user is logged in
# 3. show "Please login" unless the logged_in method returns true. logged_in method
# 4. logged_in method check for logged_in_user is true
# 5. logged_in_user runs
# 6. decoded_token runs partially then then grabs the information from auth_header method, then finishes executing
