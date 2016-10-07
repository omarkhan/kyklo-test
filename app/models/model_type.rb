class ModelType < ActiveRecord::Base
  belongs_to :model
  validates :base_price, numericality: { greater_than: 0 }
end
