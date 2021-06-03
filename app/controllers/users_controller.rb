class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, except: %i[signup create login]
  before_action :set_user, only: %i[show update destroy logout deactivate_activate]

  # GET /users
  def index
    @users = if @current_user.role.name == 'user' || @current_user.role.name == 'admin'
               User.where(is_approved: 1, is_active: true, role: Role.where(name: %w[user admin]).ids)
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
      render json: { status: 'error', message: @user.errors.full_messages.first }
    end
  end

  # POST /user/signup
  def signup
    @user = User.new(signup_params)
    @user.perform_action = 'signup'
    @user.update_user_role('super_admin')
    if @user.save
      token = @user.generate_token
      render json: { user: @user, role: @user.role.name, token: token }, status: :created
    else
      render json: { status: 'error', message: @user.errors.first.message }
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
    # Error handling
    raise 'Email does not exists' if @user.nil?
    is_authenticated = @user.authenticate(params[:password])
    raise 'User has been deactivated' unless @user.is_active
    raise 'Email/Password does not match' unless is_authenticated

    if is_authenticated
      token = @user.generate_token
      render json: { token: token, user: @user, role: @user.role.name }, status: :ok
    end
  rescue StandardError => e
    render json: { status: 'error', message: e.message }
  end

  # POST /users/1/logout
  def logout
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @user.user_tokens.where(token: header).update_all(active: 0)
    render json: {}, status: :ok
  end

  # PUT /users/1/deactivate - deactivate user/admin
  def deactivate_activate
    @user.update_column(:is_active, !@user.is_active)
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
