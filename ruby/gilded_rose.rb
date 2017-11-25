class GildedRose
  # These exceptions can increase or decrease
  QUALITY_EXCEPTIONS = ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert", "Sulfuras, Hand of Ragnaros"].freeze

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      update_sell_in(item)

      unless QUALITY_EXCEPTIONS.include?(item.name)
        change_quality(item, amount: -1)
        change_quality(item, amount: -1) if item.sell_in < 0
      else
        change_quality(item)

        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          change_quality(item) if item.sell_in < 10
          change_quality(item) if item.sell_in < 5
        end
      end

      # after 0 sell in
      if item.sell_in < 0
        change_quality(item) if item.name == "Aged Brie"
        item.quality = 0 if item.name == "Backstage passes to a TAFKAL80ETC concert"
      end
    end
  end

  private

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def clamp_quality(quality)
    return MAX_QUALITY if quality > MAX_QUALITY
    return MIN_QUALITY if quality < MIN_QUALITY
    quality
  end

  def update_sell_in(item)
    return if item.name == "Sulfuras, Hand of Ragnaros"
    item.sell_in = item.sell_in - 1
  end

  def change_quality(item, amount: 1)
    test_quality = clamp_quality(item.quality) + amount
    item.quality = clamp_quality(test_quality)
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
