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

require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
