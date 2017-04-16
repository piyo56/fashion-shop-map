class StaticPagesController < ApplicationController
  def home
    @shops = Shop.all
    @prefectures = Prefecture.all
  end

  def about
  end
end
