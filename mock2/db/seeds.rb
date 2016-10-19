prefecture_id = Prefecture.find_by(name: "北海道").id
Shop.find_by(name: "BShop").branches.create(name: "札幌ステラプレイス店", address:"札幌市中央区北五条西2丁目5", prefecture_id: prefecture_id)
