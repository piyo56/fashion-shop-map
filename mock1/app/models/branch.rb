class Branch < ActiveRecord::Base
  belongs_to :shop, counter_cache: :branch_num 
end
