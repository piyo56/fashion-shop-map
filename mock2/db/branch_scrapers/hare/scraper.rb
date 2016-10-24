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
shop_name       = "HARE"
short_shop_name = "HARE"
target_url      = "http://www.dot-st.com/hare/info/CSfStoreListPage.jsp"

File.open("seeds.rb", "w") do |file|
  # リソースを取得
  branch_list_page = fetch_page(target_url)
  branches = []

  # htmlをパース(解析)してオブジェクトを生成
  branch_list_page.css(".shopList").each do |s|
    s.css("li a").each do |ss|
      branch_url  = ss.attribute("href").value.strip
      branch_name = ss.inner_text.strip

      #各店舗の情報ページを取得
      begin
        branch_info_page = fetch_page(branch_url)
        address = branch_info_page.css("td")[0].inner_text.strip
      rescue
        puts "-----> [Error] invalid branch page (#{branch_url} | #{branch_name})"
        next
      end

      begin
        branch_address = /([^a-zA-Z0-9]{1,3}?[都道府県][^\s]*[0-9]([0-9\-番号丁目])+)/.match(address)[0].strip
        puts "\t* #{branch_name} | #{branch_address}"
      rescue
        branch_address = ""
        puts "\t---> [Error] failed to extract address str (#{branch_name})"
      end

      # 配列に保存
      branches.push({name: branch_name, url: target_url, address: branch_address})

      # seedsに書き出し
      branch_prefecture = address2prefecture(branch_address)
      if branch_prefecture
        code = %(prefecture_id = Prefecture.find_by(name: "#{branch_prefecture}").id\n)
        code += %(Shop.find_by(name: "#{shop_name}").branches.create(name: "#{shop_name} #{branch_name}", address:"#{branch_address}", prefecture_id: prefecture_id)\n)
        file.write(code)
      end
    end
  end
end
