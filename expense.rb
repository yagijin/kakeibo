class Expense
  attr_reader :shop_name
  attr_accessor :amount

  def initialize(shop_name, amount = 0)
    @shop_name = shop_name   # 利用加盟店
    @amount =  amount # 利用金額
  end

  def add(price)
    @amount += price
  end

  def percent(total)
    (amount/total.to_f * 100).round(2)
  end
end
