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

require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
