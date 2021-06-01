class PropertiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request
  before_action :set_property, only: %i[show update destroy add_owner update_approval_status deactivate update_availability]

  # GET /properties
  def index
    @properties = if @current_user.role.name == 'admin'
                    Property.where(is_available: 1, is_active: true)
                  elsif @current_user.role.name == 'user'
                    Property.where(is_available: 1, is_active: true, is_approved: 1)
                  else
                    Property.all
                  end
    render json: @properties
  end

  # GET /properties/1
  def show
    render json: @property
  end

  # POST /properties
  def create
    @property = Property.new(property_params)
    @property.is_active = true
    if @property.save
      render json: @property
    else
      render json: { errors: @property.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
      @property.is_active = true
      render json: @property
    else
      render json: { errors: @property.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
    render json: { head: :no_content }
  end

  # PUT /properties/1/approval_status
  def update_approval_status
    @property.update(is_approved: params[:is_approved])
    render json: @property
  end

  # PUT /properties/1/availability - When property has been purchased
  def update_availability
    @property.update(is_available: 0)
    render json: @property
  end

  # PUT /properties/1/deactivate
  def deactivate
    @property.update(is_active: 0)
    render json: @property
  end

  # GET /properties/me
  def my_properties
    if @current_user.role.name != 'super_admin'
      properties = Property.where(owner_id: @current_user.id)
      render json: properties
    else
      render json: { errors: 'Permission denied' }, status: :bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_property
    @property = Property.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def property_params
    params.permit(:name, :is_available, :is_approved, :owner_id)
  end
end
