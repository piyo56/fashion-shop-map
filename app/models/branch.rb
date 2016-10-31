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

  def self.make_latlng_uniq(branches)
    increment_num = 0.0005
    
    # frequency = {}
    branches.each_with_index do |a, i|
      # frequency["#{a.latitude}, #{a.longitude}"] = [a.address]
      branches[i..-1].each do |b|
        if b.shop_id == a.shop.id
          next
        end
        if equal_latlng(a, b)
          b.longitude += increment_num
          # frequency["#{a.latitude}, #{a.longitude}"].push(b.name+":"+b.address)
        end
      end
    end
    # puts "RESULT"
    # puts frequency.sort_by{|k, v| v.length}.reverse
    return branches
  end

  private
    # latitude, longitudeが同じかどうかを判断する
    def self.equal_latlng(a, b)
      return a.latitude == b.latitude && a.longitude == b.longitude
    end

end
