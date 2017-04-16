# == Schema Information
#
# Table name: branches
#
#  id            :integer          not null, primary key
#  name          :string
#  address       :string
#  shop_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  prefecture_id :integer
#

class Branch < ActiveRecord::Base
  belongs_to :shop, counter_cache: true
  belongs_to :prefecture

  validates :name, presence: true, uniqueness: true
  geocoded_by :address
  after_validation :geocode

  scope :with_shop, -> { includes(:shop) }
  scope :with_prefecture, -> { includes(:prefecture) }
  scope :of_shops, -> ids { where("shop_id IN (?)", ids) }
  scope :in_prefecutres, -> ids { where("prefecture_id IN (?)", ids) }

  def self.search(sid, pid)
    Branch.where(shop_id: sid, prefecture_id: pid)
  end

  def self.make_latlng_uniq(branches)
    increment_num = 0.0001
    
    # frequency = {}
    branches.each_with_index do |a, i|
      # frequency["#{a.latitude}, #{a.longitude}"] = [a.address]
      branches[i..-1].each do |b|
        if b.shop_id == a.shop_id
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
      if a.latitude.nil? || b.latitude.nil? || a.longitude.nil? || b.longitude.nil?
        return false
      end
      return a.latitude == b.latitude && a.longitude == b.longitude
    end

end
