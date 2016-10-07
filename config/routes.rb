Rails.application.routes.draw do
  get '/:organization/models/:model_slug/model_types', to: 'model#list'
  post '/:organization/models/:model_slug/model_types_price/:model_type_slug', to: 'model#create'
end
