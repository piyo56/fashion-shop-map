class Shop < ActiveRecord::Base
  has_many :branches
  validates :name, presence: true, uniqueness: true

  def self.fetch_branches(shop_ids, prefecture_ids)
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
      hit_branch_ids = branches_of_shops & branches_in_prefectures
    else
      hit_branch_ids = branches_of_shops
    end 

    hit_branches = []
    hit_branch_count = {}
    hit_branch_ids.each do |branch_id|
      b = Branch.find(branch_id)

      # ヒットした店舗を追加
      hit_branches.push(b)

      # ヒットした店舗数をカウント
      hit_branch_count[b.shop_id.to_s] ||= 0
      hit_branch_count[b.shop_id.to_s] += 1
    end

    return hit_branch_count, hit_branches
  end
end
