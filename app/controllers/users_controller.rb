class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[signup login create update logout]
  before_action :authorize_request, except: %i[signup create login]
  before_action :set_user, only: %i[show update destroy logout]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/1
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # POST /user/signup
  def signup
    @user = User.new(signup_params)
    @user.role = 'SUPER_ADMIN'
    if @user.save
      render json: { user: @user }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render json: { head: :no_content }
  end

  # POST /users/login
  def login
    @user = User.find_by_email(params[:email])
    raise 'Email Does not exists' if @user.nil?

    # Setting password digest because authenticate method internally checks for this attribute
    @user.password_digest = @user.encrypted_password
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = (Time.now + 24.hours.to_i).strftime('%m-%d-%Y %H:%M')
      @user.store_user_tokens(token, time)
      render json: { token: token, exp: time, user: @user }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # POST /users/1/logout
  def logout
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @user.user_tokens.where(token: header).update_all(active: 0)
    render json: {}, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:name, :email, :password, :role)
  end

  # Only allow a list of trusted parameters through.
  def signup_params
    params.permit(:name, :email, :password)
  end

  # Login params used to login to app
  def login_params
    params.permit(:email, :password)
  end
end
