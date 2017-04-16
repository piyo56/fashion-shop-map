# == Schema Information
#
# Table name: prefectures
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  region     :string
#

class Prefecture < ActiveRecord::Base
  has_many :branches
end
