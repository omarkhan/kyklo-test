class Organization < ActiveRecord::Base
  has_and_belongs_to_many :models
  enum organization_type: [:show_room, :service, :dealer]
  enum pricing_policy: [:flexible_pricing, :fixed_pricing, :prestige_pricing]
end
