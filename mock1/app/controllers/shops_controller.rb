class ShopsController < ApplicationController

  def index
    @shops = Shop.all
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to shops_path
    else
      render "index"
    end
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def edit
  end

  def destroy
  end

  private
  
  def shop_params
    params.require(:shop).permit(:name, :mens, :ladies)
  end
end
