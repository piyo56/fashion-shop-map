class ShopsController < ApplicationController
  before_action :set_shops, only: [:index, :show]
  before_action :set_prefectures, only: [:index, :show]

  def index
  end

  def show
    if !params[:s_ids].nil?
      begin
        @selected_shop_ids       = params[:s_ids].map{|id| id.to_i} 
        @selected_prefecture_ids = params[:p_ids].map{|id| id.to_i} if params[:p_ids].nil?
        @branches = fetch_branches(@selected_shop_ids, @selected_prefecture_ids) 
      rescue => e
        @error_msg = "GET Parameter is not valid"
        ErrorUtility.log_and_notify e
      end

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
    else
      @error_msg = "invalid get parameters"
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

    def fetch_branches(shop_ids, prefecture_ids)
      shop_ids       ||= []
      prefecture_ids ||= []

      if shop_ids.length == 0
        raise "shop_ids is not given."
      end

      # 選択されたショップの店舗idの配列
      branches_of_shops = shop_ids.map{|id| Shop.find(id).branches.pluck(:id)}.flatten!
      
      # 選択された県にある店舗idの配列
      branches_in_prefectures = prefecture_ids.map{|id| Prefecture.find(id).branches.pluck(:id)}.flatten!

      # 上記両方を満たす店舗の配列
      if branches_in_prefectures
        selected_branches = branches_of_shops & branches_in_prefectures
      else
        selected_branches = branches_of_shops
      end 
      return selected_branches.map{|id| Branch.find(id)}
    end
end

