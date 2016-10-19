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
shop_name       = "SHIPS"
short_shop_name = "SHIPS"
target_url      = "https://www.shipsltd.co.jp/?s&post_type=shop&sa%5B0%5D=1&sa%5B1%5D=2&sa%5B2%5D=3&sa%5B3%5D=4&sa%5B4%5D=5&sa%5B5%5D=6&sa%5B6%5D=7&sb%5B0%5D=ships_men&shoptype"
num_pages = (1..4).to_a

File.open("seeds.rb", "w") do |file|
  num_pages.each do |p|
    page_arg = "&paged=#{p}"

    # リソースを取得
    branch_list_page = fetch_page(target_url + page_arg)
    branches = []

    # htmlをパース(解析)してオブジェクトを生成
    branch_list_page.css('.info').each do |s|
      branch_name = s.css('.name > a').inner_text.strip
      branch_url  = s.css('.name > a').attribute("href").value 
      address = s.css('.address').inner_text.strip

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
        code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{shop_name.split[2]} #{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
        file.write(code)
      end
    end
  end
end
