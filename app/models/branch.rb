# class LatLngValidator < ActiveModel::Validator
#   def validate(record)
#     lat = record.latitude
#     lng = record.longitude
#     delta = 30 / 1000000
#
#     branches = Branch.all.select(:latitude, :longitude)
#     branches.each do |b|
#       if lat == b[:latitude] && lng == b[:longitude]
#         record.latitude += delta
#       end
#     end
#   end
# end

class Branch < ActiveRecord::Base
  belongs_to :shop, counter_cache: true
  belongs_to :prefecture

  validates :name, presence: true, uniqueness: true

  # include ActiveModel::Validations
  # validates_with LatLngValidator
  
  geocoded_by :address
  after_validation :geocode

end
