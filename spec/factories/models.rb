include ActionDispatch::TestProcess

FactoryGirl.define do
  ## ショップ
  factory :shop do
    sequence(:id) {|n| n}
    sequence(:name) {|n|"ショップ#{n}"}
    branches_count 0
  end

  ## 店舗
  factory :branch do
    sequence(:id) {|n| n}
    sequence(:name) {|n|"店舗#{n}"}
    address "XX県YY市ZZ町1-1-1"
    latitude 43.067934
    longitude 141.352615
    sequence(:shop_id) {|n| n}
    sequence(:prefecture_id) {|n| n}
  end
  
  # 都道府県
  factory :prefecture do
    sequence(:id) {|n| n}
    sequence(:name) {|n|"{n}県"}
    region "関東"
  end
end
