require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  setup do
    @organization = Organization.create! name: 'evil',
                                         public_name: 'Evil Corp',
                                         organization_type: :dealer,
                                         pricing_policy: :fixed_pricing
    @model = Model.create! organizations: [@organization],
                           name: 'Lamborghini',
                           model_slug: 'lamborghini'
    @model_type = ModelType.create! model: @model,
                                    name: 'Countach',
                                    model_type_slug: 'countach',
                                    model_type_code: 'test',
                                    base_price: 100_000
  end

  test 'flexible_pricing' do
    @organization.flexible_pricing!
    VCR.use_cassette('reuters') do
      assert_equal 5_717_000, @organization.price_for(@model_type)
    end
  end

  test 'fixed_pricing' do
    @organization.fixed_pricing!
    VCR.use_cassette('github') do
      assert_equal 111_825, @organization.price_for(@model_type)
    end
  end

  test 'prestige_pricing' do
    @organization.prestige_pricing!
    VCR.use_cassette('rugby') do
      assert_equal 100_053, @organization.price_for(@model_type)
    end
  end
end
