class ShopsController < ApplicationController
  before_action :set_shop, only: [:edit, :update, :destroy]
  before_action :set_shops, only: [:index, :show]
  before_action :set_prefectures, only: [:index, :show]

  def index
  end

  def show
    #@branches = Shop.fetch_branches(params[:ids])
    begin
      @branches = fetch_branches(params[:s_ids], params[:p_ids])
    rescue => e
      @error_msg = "GET Parameter is not valid"
      ErrorUtility.log_and_notify e
    end
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, notice: 'Shop was successfully created.' }
        format.json { render :show, status: :created, address: @shop }
      else
        format.html { render :new }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to @shop, notice: 'Shop was successfully updated.' }
        format.json { render :show, status: :ok, address: @shop }
      else
        format.html { render :edit }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to shops_url, notice: 'Shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    class ErrorUtility
      def self.log_and_notify(e)
        Rails.logger.error "----------------------------------[show error start]-----------------------------------------"
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
        Rails.logger.error "----------------------------------[ end ]-----------------------------------------"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:id, :name, :branches_count)
    end
    
    def set_shops
      @shops = Shop.select(:id, :name, :branches_count)
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
      branches_of_shops = shop_ids.map{|id| Shop.find(id.to_i).branches.pluck(:id)}.flatten!
      
      # 選択された県にある店舗idの配列
      branches_in_prefectures = prefecture_ids.map{|id| Prefecture.find(id.to_i).branches.pluck(:id)}.flatten!

      # 上記両方を満たす店舗の配列
      if branches_in_prefectures
        selected_branches = branches_of_shops & branches_in_prefectures
      else
        selected_branches = branches_of_shops
      end 
      return selected_branches.map{|id| Branch.find(id)}
    end
end

