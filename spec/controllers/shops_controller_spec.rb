require 'rails_helper'

RSpec.describe ShopsController, type: :controller do
  describe 'Get #map' do
    context 'リクエストに引数がない場合' do
      before do
        get :map
      end

      it 'ステータスコードが200であること' do
        expect(response).to be_success
      end

      it 'homeテンプレートを表示すること' do
        expect(response).to render_template 'static_pages/home'
      end
    end

    context 'リクエストに引数がある場合' do
      before do
        create_list(:shop, 20)
        create_list(:prefecture, 20)
        create_list(:branch, 20)
        
        @s_ids = Shop.pluck(:id).sample(10)
        @p_ids = Prefecture.pluck(:id).sample(10)
        get :map,  "s_ids": @s_ids.map(&:to_i), 
                   "p_ids": @p_ids.map(&:to_i)
      end

      it 'ステータスコードが200であること' do
        expect(response).to be_success
      end

      it 'mapテンプレートを表示すること' do
        expect(response).to render_template 'shops/map'
      end

      it 'ショップidのパラメータがセットされる' do
        expect(assigns(:selected_shop_ids)).to eq(@s_ids)
      end

      it '都道府県idのパラメータがセットされる' do
        p_ids = [2, 1, 5, 3]
        expect(assigns(:selected_prefecture_ids)).to eq(@p_ids)
      end

      it '検索条件にヒットした店舗がセットされる' do
        @branches = Branch.of_shops(@s_ids)
                          .in_prefecutres(@p_ids)
        expect(assigns(:branches)).to eq(@branches)
      end
    end
  end
end
