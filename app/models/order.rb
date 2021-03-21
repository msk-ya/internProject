class Order < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: {maximum: 10}
  validates :price, presence: true, :numericality => { :greater_than => 0 } 
  validates :num, presence: true, :numericality => { :greater_than => 0 } 
  validates :order_time, presence: true


  scope :timeSort, -> { where(order_date: Date.today ).order(order_time: :asc)}

  scope :unfinished_order, -> (user_id) {
    joins(:user).where(user_id: user_id).where(status: 2).group_by(&:order_time).sort
  }
  
  scope :finieshed_order, -> (user_id) {
    joins(:user).where(user_id: user_id).where(status: 3).group_by(&:order_date_details).sort
  }

  enum status:{
    in_order:        1, #依頼中
    processed:       2, #加工済み
    delivery:        3, #渡済み
  }

   #曜日算出
   def self.week_set(day)
    weeks = %w[日 月 火 水 木 金 土]
    weeks[day.wday]
  end


  #合計金額
  def total
    num.to_i * price.to_i
  end

  #ステータス更新
  def statusUpdate(key)
    if key == 'in_order'
      self.status = 'in_order'
      self.save
    elsif key == 'processed'
      self.status = 'processed'
      self.save
    elsif key == 'delivery'
      self.status = 'delivery'
      self.save
    end
  end

  #モーダル内のボタン当該オーダー以外を検索

  def self.otherOrders(order)
    where(user_id: order.user_id).where.not(id: order.id)
  end

  #グラフデータ(商品別)

   def self.dayTotal(datas,params)
    first_day = params.present? ? Date.parse(params).beginning_of_month : Date.today.beginning_of_month
    last_day =  last_day = first_day.end_of_month

     list_days = []                              #=>日付配列
     array = []                                  #=>最終的に返す配列
     (first_day .. last_day).each do |date|
       list_days << date
     end             

     progress_sum = 0;                           #=>進捗計算用
     list_days.each do |day|
       child_array = []                          #=>日別の配列
       total_price = 0
       total_num = 0
       datas.each do |data|
        if day == data.order_date
           total_price += data.total
           total_num  += data.num.to_i
           progress_sum += data.total
        end
       end 
       child_array << day
       child_array << total_price 
       child_array << total_num  
       child_array << progress_sum 
       array << child_array
     end
     return array
   end

  #商品別月別算出
  
  def self.saleByProduct(param_name, param_date)
    first_day = param_date.beginning_of_month
    last_day = first_day.end_of_month
    where(name: param_name, status: :delivery).where(order_date: first_day .. last_day).order(order_date: :ASC)  
  end

   #全商品オーダー月別算出

   def self.saleAllproduct(param_date)
      first_day = param_date.present? ? Date.parse(param_date).beginning_of_month : Date.today.beginning_of_month 
      last_day = first_day.end_of_month
      where(status: :delivery).where(order_date: first_day .. last_day).order(order_date: :ASC)  
   end

   #商品別月別売上合計(saleByProduct, saleAllproduct元に)
  
   def self.currentMonthSales(orders)
    total = 0
    orders.map{|order| total += order.total.to_i}
    return total
   end

  #本日商品別売上

  def self.todaySales(day)
    total = 0
    orders = where(status: :delivery).where(order_date: day).order(order_date: :DESC) 
    orders.map{|order| total += order.total.to_i}
    return total
  end

  #各商品の売上数量グラフ用 saleByProduct使用
  
  def self.salesCountArray(datas)
    sasimi_count = kirimi_count = nimono_conunt = sioyaki_count = flay_count = 0
    item_count = [sasimi_count, kirimi_count, nimono_conunt, sioyaki_count, flay_count]
    

    array = [["刺身"],["切り身"],["煮物"],["塩焼き"],["フライ"]]
    datas.each do |data|
      case data.process
      when 'sasimi'
        item_count[0] += data.num.to_i
      when 'kirimi'
        item_count[1] += data.num.to_i
      when 'nimono'
        item_count[2] += data.num.to_i
      when 'sioyaki'
        item_count[3] += data.num.to_i
      when 'flay'
        item_count[4] += data.num.to_i
      else
      end
    end

    array.each_with_index do |item, i|
      item << item_count[i]
    end
  
    return array
  end
#各商品の売上数量 saleByProduct使用

 def self.salesQuantityTable(datas, params)
  first_day =params.beginning_of_month 
  last_day = first_day.end_of_month
  hash_array = []
  (first_day .. last_day).each do |day|
    hash = {}
    hash[:day] =  day
    sasimi_count = kirimi_count = nimono_conunt = sioyaki_count = flay_count = 0
    item_count = [sasimi_count, kirimi_count, nimono_conunt, sioyaki_count, flay_count]

    datas.map do |data|
      if day == data.order_date
        case data.process
        when 'sasimi'
          item_count[0] += data.num.to_i
        when 'kirimi'
          item_count[1] += data.num.to_i
        when 'nimono'
          item_count[2] += data.num.to_i
        when 'sioyaki'
          item_count[3] += data.num.to_i
        when 'flay'
          item_count[4] += data.num.to_i
        else
        end
      end
     
    end
    hash[:sasimi] = item_count[0]
    hash[:kirimi] = item_count[1]
    hash[:nimono] = item_count[2]
    hash[:sioyaki] =item_count[3]
    hash[:flay] = item_count[4]
    total = 0
    item_count.map{|count| total += count }
    hash[:total] = total
    hash_array << hash
  end
  return hash_array
 end

#前売上数量 saleByProduct使用

 def self.totalNumber(datas)    
   total = 0
   datas.map{|data| total +=  data.num.to_i }
   return total
 end
  
  def self.sumPrises(buyings)
    sum = 0
      buyings.each do |buy| 
        sum += (buy.price.to_i * buy.num.to_i)
      end
        return sum.to_s(:delimited, delimiter: ',')
      
  end

end
