require 'open-uri'

class Organization < ActiveRecord::Base
  has_and_belongs_to_many :models

  enum organization_type: [:show_room, :service, :dealer]
  enum pricing_policy: [:flexible_pricing, :fixed_pricing, :prestige_pricing]

  def price_for(model_type)
    case pricing_policy
    when 'flexible_pricing'
      open 'http://reuters.com' do |page|
        (model_type.base_price * (page.read.count('a') / 100.0)).round(2)
      end
    when 'fixed_pricing'
      open 'https://developer.github.com/v3/#http-redirects' do |page|
        model_type.base_price + page.read.count('status')
      end
    when 'prestige_pricing'
      open 'http://www.yourlocalguardian.co.uk/sport/rugby/rss/' do |rss|
        xml = Nokogiri::XML(rss)
        model_type.base_price + xml.css('pubDate').length
      end
    end
  end
end
