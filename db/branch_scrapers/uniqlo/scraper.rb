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
shop_name       = "UNIQLO"
short_shop_name = "UNIQLO"
target_url      = "http://www.uniqlo.com/jp/shop/"

File.open("seeds.rb", "w") do |file|
  # 店舗検索TOPページ取得
  top_page = fetch_page(target_url)

  top_page.css("area").each do |prefecture_dom|
    branches = []
    branch_prefecture = prefecture_dom.attribute("alt").value
    branch_list_url   = prefecture_dom.attribute("href").value
    code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)

    print "#{branch_prefecture}: "

    # 各都道府県のページを取得
    branch_list_page = fetch_page(branch_list_url)
    branch_list_page.css('#contents > table tr').each do |row|
      branch_name    = row.css(".tit").inner_text.strip
      branch_address = row.css(".txt").inner_text.split("\n")[0].strip
      
      print "*"
      #puts "\t* #{branch_name} | #{branch_address}"

      # 配列に保存
      branches.push({name: branch_name, url: target_url, address: branch_address.split(" ")[0], long_address: branch_address, prefecture: branch_prefecture})

      # seedsに書き出し
      code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
    end
    print "\n"
    file.write(code)
  end
end
