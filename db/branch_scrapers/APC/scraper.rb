require 'uri'
require 'open-uri'
require 'nokogiri'
require 'csv'
require 'kconv'

def fetch_page(url)
  sleep(1)
  charset = nil
  html = open(url) do |f|
    raise "Got 404 error" if f.status[0] == "404"

    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end

  doc = Nokogiri::HTML.parse(html.toutf8, nil, 'utf-8')
  return doc
end

def address2prefecture(address)
  result = /(...??[都道府県])/.match(address)
  if result
    return result[0]
  else
    return nil
  end
end

# スクレイピング先の情報
shop_name       = "A.P.C"
prefectures = %w(北海道 青森 岩手 宮城 福島 新潟 栃木 埼玉 千葉 東京 神奈川 石川 福井 長野 岐阜 静岡 愛知 京都 大阪 兵庫 岡山 広島 愛媛 香川 佐賀 大分 宮崎 熊本 福岡)

File.open("seeds.rb", "w") do |file|
  branches = []

  # 日本の各都道府県の店舗を探す（だるいんご）
  prefectures.each do |prefecture|
    target_url = URI.escape("http://www.apcjp.com/jpn/shop_list?country=ja&city=#{prefecture}")

    # 次のページがある限り繰り返す
    begin
      branch_list_page = fetch_page(target_url)

      # 店舗情報をスクレイプ
      branch_names     = branch_list_page.css(".brand")
      branch_addresses = branch_list_page.css(".address")

      branch_names.each_with_index do |_, i|
        branch_name    = branch_names[i].inner_text.strip      # 店舗名
        branch_address = branch_addresses[i].inner_text.strip.split(" ")[0] # 住所
        
        # アウトレットはカウントしない
        if branch_name.include?("アウトレット")
          next
        end

        # もしbranch_nameに"A.P.C"が含んでいなかったら足す
        # かつ()の表記を含んでいればそれは取扱店（多分）なのでその旨を表記
        if !branch_name.include?(shop_name)
          if branch_name.include?("(")
            branch_name = branch_name.split("(").join("(#{shop_name}取扱店: ") # simple but no good
          else
            branch_name = "#{shop_name} #{branch_name}"
          end
        end

        puts "\t* #{branch_name} | #{branch_address}"

        # 配列に保存
        branches.push({name: branch_name, address: branch_address})

        # seedsに書き出し
        branch_prefecture = address2prefecture(branch_address)
        if branch_prefecture
          code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
          code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
          file.write(code)
        else
          puts "[error] can't extract prefecture name!!"
          puts "\t -> #{branch_name}"
        end
      end

      target_url = branch_list_page.css("li .next")
    end while target_url.length != 0
  end
end
