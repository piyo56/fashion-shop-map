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
shop_name       = "coen"
short_shop_name = "coen"
target_url      = "http://www.coen.co.jp/shop-list"
base_url        = "http://www.coen.co.jp"

File.open("seeds.rb", "w") do |file|
  # リソースを取得
  branch_list_page = fetch_page(target_url)
  branches = []

  branch_list_page.css('.slist-name').each do |s|
    branch_name = s.inner_text.strip.gsub("　", " ")
    branch_url  = s.parent.attribute("href").value
    if !branch_url.include?(base_url)
      branch_url = base_url + branch_url
    end

    #各店舗の情報ページを取得
    begin
      branch_info_page = fetch_page(branch_url)
    rescue
      puts "-----> [Error] failed to fetch the page (#{branch_name} | #{branch_url})"
      next
    end
    
    address = branch_info_page.css('.address').inner_text

    # 全角スペースは半角に切り替えて、空白を用いて後ろの不要そうな情報は消す
    address = address.gsub("　", " ").split(" ")[0..1].join(" ")
    
    # 全角数字は半角数字に変換する
    address = address.tr('０-９', '0-9')

    # 英字が出てきたらその一個前から末尾まで削除
    address = address.sub(/[0-9][a-zA-Z].*/, "")

    begin
      branch_address = /([^a-zA-Z0-9]{1,3}?[都道府県][^\s]*[0-9]([0-9\-番号丁目])+)/.match(address)[0].strip
      puts "\t* #{branch_name} | #{branch_address}"
    rescue
      branch_address = ""
      puts "\t---> [Error] failed to extract address str (#{branch_url} | #{branch_name})"
    end

    # 配列に保存
    branches.push({name: branch_name, url: target_url, address: branch_address})

    # seedsに書き出し
    branch_prefecture = address2prefecture(branch_address)
    if branch_prefecture
      code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
      code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{short_shop_name} #{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
      file.write(code)
    end
  end
end
