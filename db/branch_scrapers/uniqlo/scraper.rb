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
  
  html = html.toutf8.gsub!(/<script[^>]*>.*?<\/script>/m, "")
  doc = Nokogiri::HTML.parse(html, nil, 'utf-8') do |config|
   config.noblanks.strict.nonet
  end

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
shop_name       = "UNIQLO"
prefecutres = ["北海道", "青森県", "秋田県", "岩手県", "山形県", "宮城県", "新潟県", "福島県", "富山県", "石川県", "福井県", "茨城県", "栃木県", "群馬県", "長野県", "千葉県", "埼玉県", "東京都", "神奈川県", "山梨県", "静岡県", "愛知県", "岐阜県", "三重県", "滋賀県", "大阪府", "京都府", "奈良県", "和歌山県", "兵庫県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "香川県", "徳島県", "高知県", "愛媛県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
  
File.open("seeds.rb", "w") do |file|

  # 各都道府県の店舗をスクレイピング
  prefecutres.each_with_index do |prefecutre_name, prefecutre_id|

    seeds_code  = %(prefecture_id = Prefecture.find_by(name: "#{prefecutre_name}").id\n)
    branch_list_url = "http://www.uniqlo.com/jp/shop/c/all/index_#{prefecutre_id + 1}.html"

    # 店舗情報取得
    branch_list_page = fetch_page(branch_list_url)
    puts "#{prefecutre_name}: #{branch_list_page.css("#contents table tr").length}"
    branch_list_page.css("table tr").each do |row|

      # 名前と住所
      branch_name    = row.css(".tit").inner_text.strip
      branch_address = row.css(".txt").inner_text.split("\n")[0]
      
      # なぜか一行ごとに空のカラムが入っているのでその場合はスルー
      if branch_name.empty?
        next
      end

      # 閉店(した|する)場合はスキップ
      if branch_name.include?("閉店")
        next
      end

      # seedsに書き出し
      seeds_code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
    end
    file.write(seeds_code)
  end
end
