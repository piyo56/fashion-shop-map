class Shop < ActiveRecord::Base
  has_many :branches
  validates :name, presence: true, uniqueness: true
end
