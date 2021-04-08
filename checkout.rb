# Simple checkout calculator
# Accepts rules hash on input that is a list of promotional rules
# The format of the rules hash:
# total_discount - a hash that contains a max total price for a discount
# and a discount percent, example:
# total_discount: { amount: 60, percent: 0.1 }
# Item discounts is a hash containing the quantity for discount
# and a discount amount, example:
# '001': { discount_threshold: 2, discounted_price: 8.50 }
class Checkout
  attr_reader :rules, :total, :items

  def initialize(rules = {})
    @rules = rules
    @total = 0.0
    @items = {}
  end

  # Accepts a instance of the Item class and recalculates total
  # using provided promotional rules
  def scan(item)
    add_item(item)
    recalculate_total
    round_total
  end

  private

  def add_item(item)
    items[item.code] ||= { price: item.price, quantity: 0 }
    items[item.code][:quantity] += 1
  end

  def recalculate_total
    @total = 0
    items.each do |item_code, item_data|
      item_price = get_item_price(item_code.to_sym, item_data)
      item_total = item_price * item_data[:quantity]
      @total += item_total
    end
    calculate_total_discount
  end

  def get_item_price(code, data)
    discount_threshold = rules.dig(code, :discount_threshold)
    return data[:price] if discount_threshold.nil? || discount_threshold > data[:quantity]
    rules.dig(code, :discounted_price)
  end

  def calculate_total_discount
    discountable_amount = rules.dig(:total_discount, :amount)
    discount_percent = rules.dig(:total_discount, :percent)
    return unless discountable_amount && discount_percent && @total > discountable_amount
    @total -= @total * discount_percent
  end

  def round_total
    @total = @total.round(2)
  end
end

# Item class that represents product abstraction
# Contains name, code and a price for one item
class Item
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = price
  end
end
