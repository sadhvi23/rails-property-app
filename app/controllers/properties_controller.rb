class PropertiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request
  before_action :set_property, only: %i[show update destroy add_owner update_approval_status deactivate]

  # GET /properties
  def index
    @properties = if @current_user.role.name == 'user'
                    Property.where(is_approved: 1)
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
    if @property.save
      render json: @property
    else
      render json: { errors: @property.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
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

  # post /properties/1/add_owner
  def add_owner
    @property.user_properties.create(params[:user_id])
    render json: { property: @property, user_properties: @property.user_properties.last }
  end

  # PUT /properties/1/approval_status
  def update_approval_status
    @property.update(is_approved: params[:is_approved])
    render json: @property
  end

  # PUT /properties/1/availability - When property has been purchased
  def update_availability
    @property.update(is_available: params[:is_available])
    render json: @property
  end

  # PUT /properties/1/deactivate
  def deactivate
    @property.update(is_active: 0)
    render json: @property
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_property
    @property = Property.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def property_params
    params.permit(:name, :is_active, :is_available, :is_approved)
  end
end
