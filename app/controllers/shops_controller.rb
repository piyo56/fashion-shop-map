class ShopsController < ApplicationController
  before_action :set_shops, only: [:index, :show]
  before_action :set_prefectures, only: [:index, :show]

  def index
  end

  def show
    # ショップIDがなければエラー
    if params[:s_ids].nil?
      @error_msg = "invalid get parameters"
      return
    end

    begin
      @selected_shop_ids       = params[:s_ids].map{|id| id.to_i} 
      @selected_prefecture_ids = params[:p_ids].map{|id| id.to_i} if !params[:p_ids].nil?
      @hit_branches_count, @branches = Shop.fetch_branches(@selected_shop_ids, @selected_prefecture_ids) 
      puts "before: #{@branches.length}"
      @branches = Branch.make_latlng_uniq(@branches)
      puts "after: #{@branches.length}"
    rescue => e
      @error_msg = "GET Parameter is not valid"
      ErrorUtility.log_and_notify e
    end
    
    # Gmapのmarkerオブジェクトの配列を作成
    @branch_markers = Gmaps4rails.build_markers(@branches) do |branch, marker|
      marker.lat branch.latitude
      marker.lng branch.longitude
      marker.infowindow branch.name
      marker.picture({
        url: "/assets/#{branch.shop_id}.png",
        width:   32,
        height:  32,
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

    def set_shops
      @shops = Shop.order("name").select(:id, :name, :branches_count)
    end
    
    def set_prefectures
      @prefectures = Prefecture.select(:id, :name)
    end
end

