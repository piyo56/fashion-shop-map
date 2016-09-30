class MapController < ApplicationController
  def index
    @all_shops = Shop.all
    #@all_shops  = all_shops.pluck(:id, :name, :branches_count)
  end

  def show
    logger.debug params
  end
end
