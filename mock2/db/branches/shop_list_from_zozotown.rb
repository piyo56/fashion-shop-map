require 'open-uri'
require 'nokogiri'
require 'csv'

class ShopListScraper
  def initialize(base_url, target_url)
    @base_url = base_url
    @target_url = target_url
    @tmp_save_file = __FILE__.split('.')[0] + ".tmp.saved"
    if File.exist?(@tmp_save_file)
      File.open(@tmp_save_file, "r") do |file|
        @shops = deserialize(file)
      end
      @tmp_saved_num = @shops.length
    else
      @shops = []
      @tmp_saved_num = 0
    end
  end
  
  def scrape
    File.open(@tmp_save_file, "w") do |file|
      # htmlをパース(解析)してオブジェクトを生成
      fetch_page(@target_url).xpath("//a[@class='path']")[(@tmp_saved_num)..-1].each do |shop_div|
        shop = {name: "", zozo_url:"", official_url:""}
        shop[:zozo_url] = @base_url + shop_div.attribute('href').value
        shop[:name] = shop_div.css('span').inner_text.strip

        official_url_div = fetch_page(shop[:zozo_url]).css("#officialSite")[0]
        shop[:official_url] = official_url_div.children[0].attribute("href").value if official_url_div
        
        log(shop)
        @shops << shop
        serialize(file)
      end
    end
  end

  def save(filename)
    write_as_csv(filename)
  end

  private

  def log(shop)
    puts "\t* #{shop[:name]} (#{shop[:official_url].length>0})"
  end

  def serialize(file)
    file.write(Marshal.dump(@shops))
  end

  def deserialize(file)
    Marshal.load(file.read)
  end

  def fetch_page(url)
    sleep(1)
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    return doc
  end

  def hash_list_to_csv_array( list, key_order=nil )
    # http://qiita.com/metheglin/items/439d1fd9b0e0e53c6051
    key_order ||= list.map(&:keys).flatten.uniq
    arr = list.map do |hash|
      key_order.map{|key| hash[key]}
    end
    arr.unshift(key_order)
  end

  def write_as_csv(filename)
    # CSV
    File.open(filename, "w") do |file|
    #File.open("#{__FILE__.split('.')[0]}.txt", "w") do |file|
      file.write(hash_list_to_csv_array(@shops).map(&:to_csv).join)
    end
  end
end

shop_list = ShopListScraper.new("http://zozo.jp", "http://zozo.jp/shop/?c=SwitchType&ts=1&p_no=1")
shop_list.scrape
shop_list.save("all_shop_list.csv")
