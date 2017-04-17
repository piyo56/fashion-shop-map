class ShopsController < ApplicationController
  before_action :set_shop, only: [:show]
  before_action :set_shops, only: [:index, :map]
  before_action :set_prefectures, only: [:map]

  def index
  end

  def show
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
end

