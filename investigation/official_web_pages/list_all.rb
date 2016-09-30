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

def debug(var)
  p var
  gets.to_i
end

def hash_list_to_csv_array( list, key_order=nil )
  # http://qiita.com/metheglin/items/439d1fd9b0e0e53c6051
  key_order ||= list.map(&:keys).flatten.uniq
  arr = list.map do |hash|
    key_order.map{|key| hash[key]}
  end
  arr.unshift(key_order)
end

# スクレイピング先のURL
target_url = "http://www.fashion-press.net/brands/search/5/select"
base_url = "http://www.fashion-press.net"

# リソースを取得
shop_list_page = scrape(target_url)
shops = []

# htmlをパース(解析)してオブジェクトを生成
shop_list_page.css('#b-slist')[0].css("li").each do |shop_about|
  shop_name = shop_about.css('a').inner_text.strip
  shop_url = shop_about.css('a').attribute('href').value

  # セレクトショップの公式サイトURLを取得
  puts "\t* #{shop_name}"
  target_url = base_url + shop_url

  begin
    shop_info_page = scrape(target_url)
  rescue 
    puts "-----> [Error] failed to fetch the page ( #{shop_name}. #{shop_url} )"
    next
  end

  shop_address = shop_info_page.xpath('//*[@id="col3"]/p/a').inner_text
  #puts shop_address

  # 配列に保存
  shops.push({name: shop_name, url: target_url, address: shop_address})
end

# CSV
basename = __FILE__.split('.')[0]
File.open("csv_files/#{basename}.csv", "w", :encoding => "SJIS") do |file|
#File.open("#{__FILE__.split('.')[0]}.txt", "w") do |file|
  file.write(hash_list_to_csv_array(shops).map(&:to_csv).join)
end
