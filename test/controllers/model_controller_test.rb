require 'test_helper'

class ModelControllerTest < ActionController::TestCase
  setup do
    @request.headers['Authorization'] = 'Token token=kyklo'
    @params = {
      organization: 'evil',
      model_slug: 'lamborghini',
      model_type_slug: 'gallardo',
      model_type_code: 'G',
      name: 'Gallardo',
      base_price: 150_000
    }
  end

  test 'create a new model type' do
    VCR.use_cassette('github') do
      post :create, @params
    end
    assert_response :success
    assert_equal JSON.parse(response.body), {
      'model_type' => {
        'name' => 'Gallardo',
        'base_price' => 150_000,
        'total_price' => 161_825
      }
    }
    assert_equal ModelType.count, 2
  end

  test 'create a new model type: invalid token' do
    @request.headers['Authorization'] = 'Token token=invalid'
    post :create, @params
    assert_response 401
  end

  test 'create a new model type: organization not found' do
    @params[:organization] = 'foo'
    post :create, @params
    assert_response :not_found
  end

  test 'create a new model type: model not found' do
    @params[:model_slug] = 'ferrari'
    post :create, @params
    assert_response :not_found
  end

  test 'create a new model type: missing param' do
    %i{name base_price model_type_code}.each do |param|
      post :create, @params.except(param)
      assert_response 422
    end
  end

  test 'create a new model type: non-numeric base_price' do
    @params[:base_price] = 'invalid'
    post :create, @params
    assert_response 422
  end

  test 'create a new model type: negative base_price' do
    @params[:base_price] = -10
    post :create, @params
    assert_response 422
  end

  test 'list model types' do
    VCR.use_cassette('github') do
      get :list, organization: 'evil', model_slug: 'lamborghini'
    end
    assert_response :success
    assert_equal JSON.parse(response.body), {
      'models' => [
        {
          'name' => 'Lamborghini',
          'model_types' => [
            {
              'name' => 'Countach',
              'total_price' => 111_825
            }
          ]
        }
      ]
    }
  end

  test 'list model types: organization not found' do
    get :list, organization: 'foo', model_slug: 'lamborghini'
    assert_response :not_found
  end

  test 'list model types: model not found' do
    get :list, organization: 'evil', model_slug: 'ferrari'
    assert_response :not_found
  end
end
