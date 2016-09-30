class Shop
  def initialize(name, official_page, shop_list_page, xpaths)
    @name = name
    @official_page = official_page
    @shop_list_page = shop_list_page
    @xpaths = xpaths
  end

  def scrape
    
  end

  def save(db_path)
    db = SQLite3::Database.new db_path

  end


end

