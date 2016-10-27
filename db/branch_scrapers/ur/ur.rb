require 'open-uri'
require 'nokogiri'
require 'csv'

def fetch_page(url)
  sleep(3)
  charset = nil
  html = open(url) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)
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


File.open("ur_seeds.rb", "w") do |file|
  # スクレイピング先のURL
  base_url = "http://www.urban-research.com"
  target_url = "http://www.urban-research.com/shoplist/"

  # リソースを取得
  branch_list_page = fetch_page(target_url)
  branches = []

  # htmlをパース(解析)してオブジェクトを生成

  branch_list_page.css('.area-block-in > ul > li>  a').each do |s|
    branch_name = s.inner_text
    branch_url  = s.attribute("href").value

    # 各店舗の情報ページを取得

    begin
      branch_info_page = fetch_page(branch_url)
    rescue 
      puts "-----> [Error] failed to fetch the page ( #{branch_name}. #{branch_url} )"
      next
    end
    branch_address = branch_info_page.css('.shop-address')[0].inner_text.split[1]
    puts "\t* #{branch_name} ( #{branch_address} )"

    # 配列に保存
    branches.push({name: branch_name, url: target_url, address: branch_address})

    # seedsに書き出し
    branch_prefecture = address2prefecture(branch_address)
    shop_name = "URBAN RESEARCH"
    if branch_prefecture
      code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
      code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{shop_name} #{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
      file.write(code)
    end
  end
end
