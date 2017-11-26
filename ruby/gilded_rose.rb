class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      apply_item_rules(item)
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
    def initialize(
      update_quality: -> (_) {},
      clamp_quality: CLAMP_QUALITY,
      update_sell_in: -> (item) { item.sell_in += -1 })
      @update_quality = update_quality
      @update_sell_in = update_sell_in
      @clamp_quality = clamp_quality
    end

    def update_quality(item)
      @update_quality.call(item)
    end

    def update_sell_in(item)
      @update_sell_in.call(item)
    end

    def clamp_quality(item)
      @clamp_quality.call(item)
    end
  end

  ITEM_RULES = {
    "Aged Brie" => Artifact.new(
      update_quality: -> (item) {
        item.quality += 1
        item.quality += 1 if item.sell_in < 0
      }
    ),
    "Backstage passes to a TAFKAL80ETC concert" => Artifact.new(
      update_quality: -> (item) {
        item.quality += 1
        item.quality += 1 if item.sell_in < 10
        item.quality += 1 if item.sell_in < 5
        item.quality = 0 if item.sell_in <= 0
      }
    ),
    "Sulfuras, Hand of Ragnaros" => Artifact.new(
      update_quality: ->(item) { item.quality = 80 },
      update_sell_in: ->(_) {},
      clamp_quality: ->(_) {}
    ),
    "default" =>  Artifact.new(
      update_quality: ->(item) {
        item.quality += -1
        item.quality += -1 if item.sell_in < 0
      },
    ),
    "conjured" =>  Artifact.new(
      update_quality: ->(item) {
        item.quality += -2
        item.quality += -2 if item.sell_in < 0
      },
    )
  }

  def apply_item_rules(item)
    rule = match_rule(item)
    rule.clamp_quality(item)
    rule.update_sell_in(item)
    rule.update_quality(item)
    rule.clamp_quality(item)
  end

  def match_rule(item)
    return ITEM_RULES["conjured"] if item.name.match(/^conjured/i)
    return ITEM_RULES.fetch(item.name, ITEM_RULES["default"])
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
