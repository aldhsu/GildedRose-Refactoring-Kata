class GildedRose
  # These exceptions can increase or decrease
  QUALITY_EXCEPTIONS = ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert", "Sulfuras, Hand of Ragnaros"].freeze
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      update_sell_in(item)

      unless apply_item_rules(item)
        unless QUALITY_EXCEPTIONS.include?(item.name)
          change_quality(item, amount: -1)
          change_quality(item, amount: -1) if item.sell_in < 0
        else
          change_quality(item)
        end
      end
    end
  end

  private
  MAX_QUALITY = 50
  MIN_QUALITY = 0


  CLAMP_QUALITY = -> (item) do
    item.quality =  MAX_QUALITY if item.quality > MAX_QUALITY
    item.quality =  MIN_QUALITY if item.quality < MIN_QUALITY
  end

  class Artifact
    def initialize(update: -> (_) {}, clamp_quality: CLAMP_QUALITY)
      @update = update
      @clamp_quality = clamp_quality
    end

    def update(item)
      @update.call(item)
    end

    def clamp_quality(item)
      @clamp_quality.call(item)
    end
  end

  ITEM_RULES = {
    "Aged Brie" => Artifact.new(
      update: -> (item) {
        item.quality += 1
        item.quality += 1 if item.sell_in < 0
      }),
      "Backstage passes to a TAFKAL80ETC concert" => Artifact.new(
        update: -> (item) {
          item.quality += 1
          item.quality += 1 if item.sell_in < 10
          item.quality += 1 if item.sell_in < 5
          item.quality = 0 if item.sell_in <= 0
        }),
    # "Sulfuras, Hand of Ragnaros" => {
    #
    # }
  }

  def apply_item_rules(item)
    if rules = ITEM_RULES.fetch(item.name, nil)
      rules.update(item)
      rules.clamp_quality(item)
      true
    end
  end

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
