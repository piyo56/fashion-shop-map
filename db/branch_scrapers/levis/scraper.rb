require 'open-uri'
require 'nokogiri'
require 'csv'
require 'kconv'

def read_html_file(path)
  File.open(path, "r") do |file|
    text = file.read
    doc = Nokogiri::HTML.parse(text, nil, 'utf-8')
    return doc
  end
end

def fetch_page(url)
  sleep(2)
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
    puts "[Error] failed to extract prefecture"
    return nil
  end
end

# スクレイピング先の情報
shop_name       = "LEVI'S"
short_shop_name = "LEVI'S"
target_url      = "http://levi.jp/storefinder/"

File.open("seeds.rb", "w") do |file|
  # リソースを取得
  branch_list_page = read_html_file("html")
  branches = []

  # 店舗単位で情報を抽出
  branch_list_page.css('.list-details').each do |s|
    
    puts s
    return 

    branch_name    = s.css(".loc-name").innert_text.strip
    branch_address = s.css(".loc-addr").innert_text.strip


    puts "\t* #{branch_name} | #{branch_address}"

    # 配列に保存
    branches.push({name: branch_name, url: target_url, address: branch_address})

    # seedsに書き出し
    branch_prefecture = address2prefecture(branch_address)
    if branch_prefecture
      code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
      code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
    else
      code = %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{branch_name}", address:"#{branch_address}")\n)
    end
    file.write(code)
  end
end
