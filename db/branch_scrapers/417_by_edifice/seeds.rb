prefecture_id = Prefecture.find_by(name: "宮城県").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE エスパル仙台店", address:"宮城県仙台市青葉区中央1-1-1", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "東京都").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE 渋谷店", address:"東京都渋谷区神南1-15-5", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "東京都").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE 新宿店", address:"東京都新宿区新宿4-1-7", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "神奈川県").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE 横浜ポルタ店", address:"神奈川県横浜市西区高島2-16", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "千葉県").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE ららぽーとTOKYO-BAY店", address:"千葉県船橋市浜町2-1-1", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "大阪府").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE ららぽーとEXPOCITY店", address:"大阪府吹田市千里万博公園2-1", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "兵庫県").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE 西宮ガーデンズ店", address:"兵庫県西宮市高松町14", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "兵庫県").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE 神戸店", address:"兵庫県神戸市中央区三宮町3-5-4HK元町ビル1F078-335-1670", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "岡山県").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE 岡山店", address:"岡山県岡山市北区駅元町一番街地下086-224-810010:00〜20:00", prefecture_id: prefecture_id)
prefecture_id = Prefecture.find_by(name: "福岡県").id
Shop.find_by(name: "417 EDIFICE").branches.create(name: "417 EDIFICE 天神ソラリア店", address:"福岡県福岡市中央区天神2-2-43", prefecture_id: prefecture_id)
