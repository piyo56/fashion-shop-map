require 'open-uri'
require 'nokogiri'
require 'kconv'

# ページをフェッチしてnokogiriでパースして返す
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

# 住所から都道府県名を抜き出す
def extract_prefecture(address)
  result = /(...??[都道府県])/.match(address)
  if result
    return result[0]
  else
    return nil
  end
end

# スクレイピング先の情報
shop_name       = "THE NORTH FACE"
target_url = "http://www.goldwin.co.jp/tnf/shoplist/tnfshop.html"
 
File.open("seeds.rb", "w") do |file|

  branch_list_page = fetch_page(target_url)

  branch_list = branch_list_page.css(".table > .row")
  branch_list.shift
  
  branch_list.each do |row|
    
    branch_name    = row.css("div.name.cell.lang > div > div.ja").inner_text.strip
    branch_address = row.css("div.address.cell.lang > div > div.ja").inner_text.strip
    branch_prefecture = extract_prefecture(branch_address)
    
    puts branch_prefecture, branch_name, branch_address

    if branch_prefecture
      seeds_code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
      seeds_code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
      file.write(seeds_code)
    end
  end
end
