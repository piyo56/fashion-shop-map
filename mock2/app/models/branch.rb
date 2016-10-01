class Branch < ActiveRecord::Base
  belongs_to :shop, counter_cache: true
  #geocoded_by :address
  after_validation :geocode
end
