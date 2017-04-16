# == Schema Information
#
# Table name: shops
#
#  id             :integer          not null, primary key
#  name           :string
#  branches_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Shop < ActiveRecord::Base
  has_many :branches
  validates :name, presence: true, uniqueness: true
end
