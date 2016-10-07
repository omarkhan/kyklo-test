class ModelController < ApplicationController
  before_action :authenticate
  before_action :load_organization_and_model

  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActiveRecord::RecordInvalid,        with: :invalid_param
  rescue_from ActionController::ParameterMissing, with: :missing_param

  # POST /:organization/models/:model_slug/model_types_price/:model_type_slug
  def create
    params.require :name
    params.require :base_price
    params.require :model_type_code
    model_type = @model.model_types.create! name: params[:name],
                                            model_type_slug: params[:model_type_slug],
                                            model_type_code: params[:model_type_code],
                                            base_price: params[:base_price]
    render json: {
      model_type: {
        name: model_type.name,
        base_price: model_type.base_price.to_f,
        total_price: @organization.price_for(model_type).to_f
      }
    }
  end

  # GET /:organization/models/:model_slug/model_types
  def list
    render json: {
      models: [
        {
          name: @model.name,
          model_types: @model.model_types.map do |model_type|
            {
              name: model_type.name,
              total_price: @organization.price_for(model_type).to_f
            }
          end
        }
      ]
    }
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token|
      token == 'kyklo'
    end
  end

  def load_organization_and_model
    @organization = Organization.find_by! name: params[:organization]
    @model = @organization.models.find_by! model_slug: params[:model_slug]
  end

  def not_found
    render json: { error: 'Not found' }, status: 404
  end

  def invalid_param
    render json: { error: 'Invalid parameter' }, status: 422
  end

  def missing_param
    render json: { error: 'Missing parameter' }, status: 422
  end
end
