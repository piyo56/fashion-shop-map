class ShopsController < ApplicationController
  before_action :set_shop, only: [:edit, :update, :destroy]
  before_action :set_shops, only: [:index, :show]

  def index
    #@all_shops  = all_shops.pluck(:id, :name, :branches_count)
  end

  def show
    #@branches = Shop.fetch_branches(params[:ids])
    @branches = fetch_branches(params[:ids])
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
        format.json { render :show, status: :created, location: @shop }
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
        format.json { render :show, status: :ok, location: @shop }
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

    def fetch_branches(shop_ids)
      shop_ids.map!{|id| id.to_i}
      #shop_ids.each do |id|
      #  all_branches <<  find(id).branches.pluck(:name, :location)
      #end
      shop_ids.map{|id| Shop.find(id.to_i).branches.select(:name, :location)}
    end
end
