require File.join(File.dirname(__FILE__), 'gilded_rose')
require "pry"

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context "regular item" do
      context "quality" do
        it "reduces in quality by 1 if sell in > 0" do
          items = [Item.new("foo", 1, 1)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 0
        end

        it "reduces in quality by 2(doubles) if sell in is 0" do
          items = [Item.new("foo", 0, 2)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 0
        end

        it "reduces in quality by 2 if sell in is < 0" do
          items = [Item.new("foo", -1, 2)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 0
        end

        it "cannot reduce quality < 0" do
          items = [Item.new("foo", 0, 0)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 0
        end

        it "has max quality of 50" do
          items = [Item.new("foo", 0, 100)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 48
        end
      end

      context "Aged Brie" do
        it "increases in quality as sell_in > 0" do
          items = [Item.new("Aged Brie", 1, 0)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 1
        end

        it "increases in quality as twice as fast when sell_in >= 0" do
          items = [Item.new("Aged Brie", 0, 0)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 2
        end

        it "has max quality of 50" do
          items = [Item.new("Aged Brie", 0, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 50
        end
      end

      context "Sulfuras, Hand of Ragnaros" do
        it "never decreases its sell in time" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 999, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to be 999
        end

        it "never decreases in value" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 50
        end
      end

      context "Backstage passes to a TAFKAL80ETC concert" do
        it "has zero quality once sell in drops to 0" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 0
        end

        it "increases in quality by 1 at more than 10 days" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 0)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 1
        end

        it "increases in quality by 2 at 10 days" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 0)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 2
        end

        it "increases in quality by 2 at 6 days" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 0)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 2
        end

        it "increases in quality by 3 at 5 days" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 0)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 3
        end

        it "has a max quality of 50" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 49)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to be 50
        end
      end

      it "reduces sell in times by 1" do
        items = [Item.new("foo", 1, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to be 0
      end
    end
  end

end
