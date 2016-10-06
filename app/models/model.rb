class Model < ActiveRecord::Base
  has_and_belongs_to_many :organizations
  has_many :model_types
end
