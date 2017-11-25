class GildedRose
  QUALITY_EXCEPTIONS = ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert", "Sulfuras, Hand of Ragnaros"].freeze

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      #before update
      update_sell_in(item)

      unless QUALITY_EXCEPTIONS.include?(item.name)
        change_quality(item, amount: -1)
      else
        increase_item_quality(item)
      end

      # after update
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert" and
              item.name != "Sulfuras, Hand of Ragnaros"
            change_quality(item, amount: -1)
          else
            # zero out backstage
            item.quality = 0
          end
        else
          change_quality(item)
        end
      end

    end
  end

  private

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def clamp_quality(quality)
    test = quality > MAX_QUALITY ? MAX_QUALITY : quality
    test = test < MIN_QUALITY ? MIN_QUALITY : test
  end

  def update_sell_in(item)
    if item.name != "Sulfuras, Hand of Ragnaros"
      item.sell_in = item.sell_in - 1
    end
  end

  def increase_item_quality(item)
    change_quality(item)

    if item.name == "Backstage passes to a TAFKAL80ETC concert"
      if item.sell_in < 10
        change_quality(item)
      end
      if item.sell_in < 5
        change_quality(item)
      end
    end
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
