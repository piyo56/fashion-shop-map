class Branch < ActiveRecord::Base
  belongs_to :shop, counter_cache: true
  belongs_to :prefecture

  geocoded_by :address
  after_validation :geocode
end
