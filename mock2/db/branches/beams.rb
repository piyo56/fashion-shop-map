require 'open-uri'
require 'nokogiri'
require 'csv'

def scrape(url)
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


File.open("../seeds.rb", "w") do |file|
  # スクレイピング先のURL
  base_url = "http://www.beams.co.jp"
  target_url = 'https://www.beams.co.jp/shop/'

  # リソースを取得
  shop_list_page = scrape(target_url)
  shops = []

  # htmlをパース(解析)してオブジェクトを生成
  shop_list_page.xpath('//li[@class="beams-list-image-item"]').each do |shop_about|
    shop_name = shop_about.css('a > .shop-name').inner_text.strip
    shop_url = shop_about.css('a').attribute('href').value

    # 各店舗の情報ページを取得
    puts "\t* #{shop_name}"
    target_url = base_url + shop_url
    #debug(target_url)

    begin
      shop_info_page = scrape(target_url)
    rescue 
      puts "-----> [Error] failed to fetch the page ( #{shop_name}. #{shop_url} )"
      next
    end
    shop_detail = shop_info_page.xpath('//div[@class="shop-detail-header-left"]')[0]
    shop_address = shop_detail.css('.address').inner_text.split[0]

    # 配列に保存
    shops.push({name: shop_name, url: target_url, address: shop_address})

    # seeds.rbへと書き出し
    shop_prefecture = address2prefecture(shop_address)
    if shop_prefecture
      code = %(prefecture_id = Prefecture.find_by(name: "#{shop_prefecture}").id\n)
      code += %(Shop.find_by(name: "BEAMS").branches.create(name: "#{shop_name}", address:"#{shop_address}", prefecture_id: prefecture_id)\n)
      file.write(code)
    end
  end
end
