class ShopsController < ApplicationController
  require 'json'
  before_action :set_shop, only: [:show]
  before_action :set_shops, only: [:index, :map]
  before_action :set_prefectures, only: [:map]

  def index
  end

  def show
    all_prefectures = Prefecture.all

    # D3.jsで描画するのに必要な
    ## 都道府県の情報
    json_data = (1..47).to_a.zip(all_prefectures.pluck(:name)).to_h
    @prefectures = JSON.generate(json_data)

    ## 各県の店舗数
    json_data = {}
    branches = @shop.branches.includes(:prefecture)
    all_prefectures.each do |p|
      branches_count = branches.where(prefecture_id: p.id).count
      json_data[p.name] = to_colorcode(branches_count)
    end

    @branches = JSON.generate(json_data)
                      
    #@branches = Branch.find_by_sql("select prefectures.name as name, count(*) as branches_num from branches join prefectures on prefecture_id = prefectures.id group by prefecuture_id")
  end

  def map
    if params['p_ids'].blank? || params['s_ids'].blank?
      render 'static_pages/home' and return
    end

    begin
      @selected_shop_ids       = params['s_ids'].map{|id| id.to_i}
      @selected_prefecture_ids = params['p_ids'].map{|id| id.to_i}

      @branches = Branch.of_shops(@selected_shop_ids)
                        .in_prefecutres(@selected_prefecture_ids)
      @branches = Branch.make_latlng_uniq(@branches)
      @hit_shops = @selected_shop_ids.map do |shop_id|
        {
          name: @shops.find(shop_id).name,
          branches_count: @branches.where(shop_id: shop_id).count
        }
      end
    rescue => e
      @error_msg = "GET Parameter is not valid"
      ErrorUtility.log_and_notify e
    end
    
    # Gmapのmarkerオブジェクトの配列を作成
    @branch_markers = Gmaps4rails.build_markers(@branches) do |branch, marker|
      marker.lat branch.latitude
      marker.lng branch.longitude
      marker.infowindow "<span style='font-size: medium;'><b>#{branch.name}</b></span><br>#{branch.address}"
      marker.picture({
        url: "/assets/#{branch.shop_id}.png",
        width:   32,
        height:  44,
        clickable: false
      })
      marker.json({title: branch.name})
    end
  end

  private
    class ErrorUtility
      def self.log_and_notify(e)
        Rails.logger.error "----------------------------------[ start ]-----------------------------------------"
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
        Rails.logger.error "----------------------------------[  end  ]-----------------------------------------"
      end
    end

    def set_shop
      @shop = Shop.find(params[:id])
    end

    def set_shops
      @shops = Shop.all.order("name")
    end
    
    def set_prefectures
      @prefectures = Prefecture.all
    end

    def to_colorcode(num)
      if num == 0
        return "#ebedf0"
      elsif num < 3
        return "#c6e48b"
      elsif num < 8
        return "#7bc96f"
      elsif num < 20
        return "#239a3b"
      else
        return "#196127"
      end
    end
end
