require 'open-uri'
require 'nokogiri'
require 'uri'
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

def geocode_with_yahoo(address)
  charset = nil
  api_key = "dj0zaiZpPTJqQ1Qzelk3d0lNMSZzPWNvbnN1bWVyc2VjcmV0Jng9MWU-"

  url = "http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder?appid=#{api_key}&query=#{URI.escape(address)}"

  xml = open(url) do |f|
    raise "Got 404 error" if f.status[0] == "404"
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end
  xml = xml.toutf8
  begin 
    regex = /<Coordinates[^>]*>([^<]*)<\/Coordinates>/
    results = xml.match(regex).captures[0].split(",")
  rescue
    p "geocoding failed :( | #{address}"
  end
  return results
end

# スクレイピング先の情報
shop_name       = "BEAMS"
short_shop_name = "BEAMS"
target_url      = "https://www.beams.co.jp/shop/"
base_url        = "http://www.beams.co.jp"
name_variation  = []

File.open("seeds.rb", "w") do |file|
  # リソースを取得
  branch_list_page = fetch_page(target_url)
  branches = []

  # htmlをパース(解析)してオブジェクトを生成
  branch_list_page.xpath('//li[@class="beams-list-image-item"]').each do |s|
    branch_url  = base_url + s.css("a").attribute("href").value 
    branch_name = s.css(".shop-name").inner_text.strip

    #各店舗の情報ページを取得
    begin
      branch_info_page = fetch_page(branch_url)
    rescue
      puts "-----> [Error] failed to fetch the page (#{branch_name})"
      next
    end

    branch_address = branch_info_page.css(".address").inner_text.strip

    latlng = geocode_with_yahoo(branch_address)
    longitude = latlng[0]
    latitude  = latlng[1]

    if branch_name.split[0] != "ビームス"
      next
    end
    puts "\t* #{branch_name} | #{branch_address} | (#{latitude}, #{longitude})"

    # 配列に保存
    branches.push({name: branch_name, url: target_url, address: branch_address}, latitude: latitude, longitude: longitude)

    # seedsに書き出し
    branch_prefecture = address2prefecture(branch_address)
    if branch_prefecture
      code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
      code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{shop_name.split[2]} #{branch_name}", address:"#{branch_address}", latitude:"#{latitude}", longitude:"#{longitude}, prefecture_id: prefecture_id)\n)
      file.write(code)
    end
  end
end
