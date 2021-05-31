class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, except: %i[signup create login]
  before_action :set_user, only: %i[show update destroy logout deactivate]

  # GET /users
  def index
    @users = if @current_user.role.name == 'user' || @current_user.role.name == 'admin'
               User.where(is_approved: 1, is_active: true, role: Role.where(name: ['user', 'admin']).ids)
             else
               User.all
             end
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/1
  def show
    render json: { user: @user, role: @user.role.name }, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params.except(:role))
    @user.update_user_role(user_params[:role])
    if @user.save
      UserMailer.with(user: @user, password: user_params[:password]).new_user_email.deliver_later
      render json: { user: @user, role: user_params[:role] }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # POST /user/signup
  def signup
    @user = User.new(signup_params)
    @user.perform_action = 'signup'
    @user.update_user_role('super_admin')
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      time = (Time.now + 24.hours.to_i).strftime('%m-%d-%Y %H:%M')
      @user.store_user_tokens(token, time)
      render json: { user: @user, role: @user.role.name, token: token }, status: :created
    else
      render json: { error: 'User already exists' }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    @user.update_user_role(user_params[:role]) if user_params[:role].present?
    if @user.update_columns(name: user_params[:name], email: user_params[:email])
      render json: { user: @user, role: @user.role.name }
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

    if @user&.is_active
      # Setting password digest because authenticate method internally checks for this attribute
      sha1_password = Digest::SHA1.hexdigest("#{@user.encrypted_password}#{params[:password]}")
      @user.password_digest = BCrypt::Password.create(sha1_password).to_s
      if @user&.authenticate(sha1_password)
        token = JsonWebToken.encode(user_id: @user.id)
        time = (Time.now + 24.hours.to_i).strftime('%m-%d-%Y %H:%M')
        @user.store_user_tokens(token, time)
        render json: { token: token, exp: time, user: @user, role: @user.role.name }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    else
      render json: { error: 'User has been deactivated' }, status: :unprocessable_entity
    end
  end

  # POST /users/1/logout
  def logout
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @user.user_tokens.where(token: header).update_all(active: 0)
    render json: {}, status: :ok
  end

  # PUT /users/1/deactivate - deactivate user/admin
  def deactivate
    @user.update_column(:is_active, false)
    render json: @user
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
