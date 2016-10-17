prefecture_id = Prefecture.find_by(name: "鹿児島県").id
Shop.find_by(name: "JOURNAL STANDARD").branches.create(name: "JOURNAL STANDARD 鹿児島店", address:"鹿児島県鹿児島市中央町1−1", prefecture_id: prefecture_id)
