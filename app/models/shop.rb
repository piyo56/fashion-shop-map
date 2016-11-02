class Shop < ActiveRecord::Base
  has_many :branches
  validates :name, presence: true, uniqueness: true

  def self.fetch_branches(selected_shop_ids, selected_prefecture_ids)
    selected_shop_ids       ||= []
    selected_prefecture_ids ||= []

    if selected_shop_ids.length == 0
      raise "shop_ids are not given."
    end
    if selected_prefecture_ids.length == 0
      raise "prefecture_ids are not given."
    end

    # 選択されたショップの店舗idの配列
    branches_of_shops = selected_shop_ids.map{|id| Shop.find(id).branches.pluck(:id)}.flatten!

    # 選択された県にある店舗idの配列
    branches_in_prefectures = selected_prefecture_ids.map{|id| Prefecture.find(id).branches.pluck(:id)}.flatten!

    p branches_in_prefectures

    # 上記両方を満たす店舗の配列
    if branches_in_prefectures
      hit_branch_ids = branches_of_shops & branches_in_prefectures
    else
      hit_branch_ids = branches_of_shops
    end 
      
    # 検索にヒットした店舗の情報を作成してreturn
    hit_branches = []
    hit_branch_count = {}
    selected_shop_ids.each{|shop_id| hit_branch_count[shop_id.to_s] = 0}

    hit_branch_ids.each do |branch_id|
      b = Branch.find(branch_id)
      # ヒットした店舗を追加
      if !b.latitude.nil? && !b.longitude.nil?
        hit_branches.push(b) 
      else
        next
      end

      # ヒットした店舗数をカウント
      hit_branch_count[b.shop_id.to_s] += 1
    end

    return hit_branch_count, hit_branches
  end
end
