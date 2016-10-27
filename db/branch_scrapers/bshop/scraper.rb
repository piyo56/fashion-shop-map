require 'open-uri'
require 'nokogiri'
require 'csv'
require 'kconv'

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
    return nil
  end
end

# スクレイピング先の情報
shop_name       = "BShop"
short_shop_name = "BShop"
target_url      = "http://bshop-inc.com/shop/"

File.open("seeds.rb", "w") do |file|
  # リソースを取得
  branch_list_page = fetch_page(target_url)
  branches = []

  branch_list_page.css('.link-box > li').each do |s|
    branch_name    = s.css("dt").inner_text.strip.gsub("　", " ");
    branch_url     = s.css("a").attribute("href").value
    branch_address = s.css('.addr').inner_text.strip.gsub("　", " ").split(" ")[1]

    # 配列に保存
    puts "\t* #{branch_name} | #{branch_address}"
    branches.push({name: branch_name, url: target_url, address: branch_address})

    # seedsに書き出し
    branch_prefecture = address2prefecture(branch_address)
    if branch_prefecture
      code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
      code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{short_shop_name} #{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
      file.write(code)
    else 
      puts "\t[invalid prefecture] #{branch_name} | #{branch_address}"
    end
  end
end
