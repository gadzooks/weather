class UsersController < AuthApplicationController
  skip_before_action :verify_authenticity_token

  # REGISTER
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username])

    if @user.password == params[:password]
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end

  end

=begin
  def auto_login
    render json: @user
  end
=end

  private

  def user_params
    params.permit(:username, :password)
  end

end


