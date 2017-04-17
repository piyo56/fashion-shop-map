require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'Get #home' do
    before :each do
      create_list(:shop, 20)
      create_list(:prefecture, 47)
      get :home
    end

    it 'リクエストは200 OKとなること' do
      expect(response).to be_success
    end

    it '@shopsに全てのショップを割り当てること' do
      shops = Shop.all
      prefectures = Prefecture.all
      expect(assigns(:shops)).to eq(shops)
      expect(assigns(:prefectures)).to eq(prefectures)
    end

    it ':homeテンプレートを表示すること' do
      expect(response).to render_template :home
    end
  end
end
