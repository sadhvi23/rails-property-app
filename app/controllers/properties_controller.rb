class PropertiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request
  before_action :set_property, only: %i[show update destroy add_owner]

  # GET /properties
  def index
    @properties = if @current_user.role == 'USER'
                    Property.where(approval_status: 'APPROVED')
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
    @property.updated_by_id = @property.created_by_id
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_property
    @property = Property.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def property_params
    params.permit(:name, :active, :availability_status, :created_by_id, :approval_status)
  end
end
